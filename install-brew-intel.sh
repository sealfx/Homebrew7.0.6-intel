#!/bin/bash
# ============================================================================
# install-brew-intel.sh — ติดตั้ง Homebrew 7.0.6 (Intel) + สูตรพื้นฐานจากชุดนี้
#
# ใช้เมื่อ installer ทางการของ Homebrew ปฏิเสธเครื่อง Mac Intel:
#   "Homebrew on macOS is only supported on Apple Silicon processors!"
# ชุดนี้คือสำเนา brew + Cellar ที่ติดตั้งได้จริงบน Intel (บันทึกจากเครื่อง Rak.local)
#
# วิธีใช้:   bash install-brew-intel.sh              # ติดตั้ง brew + สูตรพื้นฐาน
#            SKIP_CELLAR=1 bash install-brew-intel.sh   # เอาแค่ brew
#            PREFIX=/opt/brew bash install-brew-intel.sh # เปลี่ยนที่ติดตั้ง
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-/usr/local}"
TARBALL="$HERE/Homebrew7.0.6-intel.tar.gz"
CELLAR_TGZ="$HERE/Cellar7.0.6-intel-basics.tar.gz"

echo "== Homebrew 7.0.6 (Intel) installer =="
[ "$(uname)" = "Darwin" ] || { echo "ERROR: ชุดนี้สำหรับ macOS เท่านั้น"; exit 1; }
[ "$(uname -m)" = "x86_64" ] || { echo "ERROR: ชุดนี้สำหรับ Intel (x86_64) เท่านั้น"; exit 1; }
[ -f "$TARBALL" ] || { echo "ERROR: ไม่พบ $TARBALL"; exit 1; }
echo "   prefix: $PREFIX"

if [ -d "$PREFIX/Homebrew" ]; then
  B="$PREFIX/Homebrew.bak-$(date +%Y%m%d-%H%M%S)"
  echo "== พบ Homebrew เดิม -> สำรองไว้ที่ $B"
  sudo mv "$PREFIX/Homebrew" "$B"
fi

echo "== แตก brew ลง $PREFIX (ต้องใส่รหัส sudo)"
sudo mkdir -p "$PREFIX"
sudo tar xzf "$TARBALL" -C "$PREFIX"
sudo ln -sfn ../Homebrew/bin/brew "$PREFIX/bin/brew"
sudo chown -R "$(id -un)" "$PREFIX/Homebrew" "$PREFIX/bin" 2>/dev/null || true

# สร้าง git repo เล็ก + tag เพื่อให้ brew รายงานเวอร์ชันถูกต้อง
if [ ! -d "$PREFIX/Homebrew/.git" ] && command -v git >/dev/null 2>&1; then
  echo "== สร้าง git tag ให้ brew รู้จักเวอร์ชัน"
  ( cd "$PREFIX/Homebrew" \
    && git init -q . \
    && git add -A >/dev/null 2>&1 \
    && git -c user.email=kit@localhost -c user.name="Homebrew Intel Kit" commit -qm "Homebrew 7.0.6 (Intel) snapshot" >/dev/null 2>&1 \
    && git tag -f 7.0.6 >/dev/null 2>&1 ) || true
fi

# ติดตั้งสูตรที่แนบมากับชุด
if [ -f "$CELLAR_TGZ" ] && [ "${SKIP_CELLAR:-0}" != "1" ]; then
  echo "== ติดตั้งสูตรพื้นฐานที่แนบมากับชุด"
  sudo tar xzf "$CELLAR_TGZ" -C "$PREFIX"
  sudo chown -R "$(id -un)" "$PREFIX/Cellar" "$PREFIX/opt" 2>/dev/null || true
  export PATH="$PREFIX/bin:$PATH"
  echo "== link คำสั่งของสูตรเหล่านั้น"
  for d in "$PREFIX"/Cellar/*; do
    [ -d "$d" ] || continue
    brew link --overwrite --force "$(basename "$d")" >/dev/null 2>&1 || true
  done
  echo "   linked: $(ls "$PREFIX"/Cellar 2>/dev/null | wc -l | tr -d ' ') formulae"
fi

PROFILE="$HOME/.zprofile"; touch "$PROFILE"
grep -q "brew shellenv" "$PROFILE" 2>/dev/null || echo "eval \"$("$PREFIX"/bin/brew shellenv)\"" >> "$PROFILE"
grep -q "HOMEBREW_NO_AUTO_UPDATE" "$PROFILE" 2>/dev/null || echo 'export HOMEBREW_NO_AUTO_UPDATE=1' >> "$PROFILE"

echo "== ตรวจสอบ"
export PATH="$PREFIX/bin:$PATH"
brew --version || true
echo "== เสร็จแล้ว — เปิด Terminal ใหม่แล้วพิมพ์: brew --version"
