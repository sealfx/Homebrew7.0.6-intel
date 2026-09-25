#!/bin/bash
# ============================================================================
# install-brew-intel.sh — ติดตั้ง Homebrew 7.0.6 (Intel) จากชุดนี้
#
# ใช้เมื่อ installer ทางการของ Homebrew ปฏิเสธเครื่อง Mac Intel:
#   "Homebrew on macOS is only supported on Apple Silicon processors!"
# ชุดนี้คือสำเนา brew ที่ติดตั้งได้จริงบน Intel (บันทึกจากเครื่อง Rak.local)
#
# วิธีใช้:   bash install-brew-intel.sh
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-/usr/local}"
TARBALL="$HERE/Homebrew7.0.6-intel.tar.gz"

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

echo "== แตกไฟล์ลง $PREFIX  (ต้องใส่รหัส sudo)"
sudo mkdir -p "$PREFIX"
sudo tar xzf "$TARBALL" -C "$PREFIX"
sudo ln -sfn ../Homebrew/bin/brew "$PREFIX/bin/brew"
sudo chown -R "$(id -un)" "$PREFIX/Homebrew" "$PREFIX/bin" 2>/dev/null || true

# 3.5) สร้าง git repo ขนาดเล็ก + tag 7.0.6 เพื่อให้ brew รายงานเวอร์ชันถูกต้อง
#      (ชุดนี้ไม่รวม .git ของ upstream โดยตั้งใจ -> ป้องกันการดึงโค้ดที่ไม่รองรับ Intel)
if [ ! -d "$PREFIX/Homebrew/.git" ] && command -v git >/dev/null 2>&1; then
  echo "== สร้าง git tag ให้ brew รู้จักเวอร์ชัน"
  ( cd "$PREFIX/Homebrew" \
    && git init -q . \
    && git add -A >/dev/null 2>&1 \
    && git -c user.email=kit@localhost -c user.name="Homebrew Intel Kit" commit -qm "Homebrew 7.0.6 (Intel) snapshot" >/dev/null 2>&1 \
    && git tag -f 7.0.6 >/dev/null 2>&1 ) || true
fi


PROFILE="$HOME/.zprofile"; touch "$PROFILE"
grep -q "brew shellenv" "$PROFILE" 2>/dev/null || echo "eval \"$("$PREFIX"/bin/brew shellenv)\"" >> "$PROFILE"
grep -q "HOMEBREW_NO_AUTO_UPDATE" "$PROFILE" 2>/dev/null || echo 'export HOMEBREW_NO_AUTO_UPDATE=1' >> "$PROFILE"

echo "== ตรวจสอบ"
export PATH="$PREFIX/bin:$PATH"
brew --version
echo
echo "== เสร็จแล้ว — เปิด Terminal ใหม่แล้วพิมพ์: brew --version"
echo "   (ชุดนี้ตั้ง HOMEBREW_NO_AUTO_UPDATE=1 ให้ เพื่อไม่ให้ brew อัปเดตตัวเองเป็นตัวที่ไม่รองรับ Intel)"
