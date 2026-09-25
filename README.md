# Homebrew 7.0.6 — Intel portable kit (+ สูตรพื้นฐาน)

ชุดติดตั้ง Homebrew สำหรับ Mac **Intel** ในยุคที่ Homebrew ตัดการรองรับ Intel แล้ว

## ทำไมต้องมีชุดนี้

ตัวติดตั้งทางการ (`install.sh`) ปัจจุบันปฏิเสธเครื่อง Intel:

```bash
# On macOS, support Apple Silicon only
if [[ "${UNAME_MACHINE}" != "arm64" ]]; then
  abort "Homebrew on macOS is only supported on Apple Silicon processors!"
fi
```

ชุดนี้คือสำเนา brew + Cellar ที่ติดตั้งและใช้งานได้จริง (บันทึกจากเครื่อง Intel) เพื่อติดตั้งซ้ำในอนาคต

## ไฟล์ในชุด

| ไฟล์ | ขนาด | รายละเอียด |
|---|---|---|
| `Homebrew7.0.6-intel.tar.gz` | ~27 MB | brew 7.0.6 (ไม่มี `.git` upstream — ตั้งใจ กัน `brew update` ไปดึงตัวที่ไม่รองรับ Intel) |
| `Cellar7.0.6-intel-basics.tar.gz` | ~50 MB | สูตรพื้นฐานที่ compile/บิลด์ไว้แล้ว (~37 สูตร) |
| `FORMULAE.txt` | — | รายการสูตรในชุด + เวอร์ชัน |
| `install-brew-intel.sh` | — | สคริปต์ติดตั้งทั้งหมด |
| `VERSION.txt` · `LICENSE.txt` | — | เวอร์ชัน/ที่มา · สัญญาอนุญาต (BSD-2-Clause) |

**สูตรที่แนบมา:** bat, brotli, ca-certificates, curl, fd, gmp, htop, jq, libnghttp2/3, libpsl, libssh2, lz4, ncdu, ncurses, oniguruma, openssl@3, pcre2, pkgconf, readline, ripgrep, simdjson, sqlite, syncthing, tree, xz, zstd, autoconf/automake/libtool/m4 ฯลฯ
**ไม่รวม (ติดตั้งเพิ่มได้):** `go`, `python@3.12`, `python@3.14`, `cmake` — เพราะไฟล์ใหญ่ (~660 MB)

## วิธีใช้

```bash
# ดาวน์โหลดทั้งชุด (จาก NAS ในวง LAN — เร็ว)
curl -O http://rakguitar.local/Homebrew7.0.6-intel/Homebrew7.0.6-intel.tar.gz
curl -O http://rakguitar.local/Homebrew7.0.6-intel/Cellar7.0.6-intel-basics.tar.gz
curl -O http://rakguitar.local/Homebrew7.0.6-intel/install-brew-intel.sh
bash install-brew-intel.sh

# หรือจาก GitHub
git clone https://github.com/sealfx/Homebrew7.0.6-intel.git /tmp/hbk && cd /tmp/hbk && bash install-brew-intel.sh
```

ตัวเลือก: `SKIP_CELLAR=1` (เอาแค่ brew) · `PREFIX=/opt/brew` (เปลี่ยนที่ติดตั้ง)

## หลังติดตั้ง

```bash
brew --version
brew install <formula>              # ติดตั้งเพิ่มได้ตามปกติ
brew list                           # ดูสูตรที่ติดตั้ง
```

## ข้อควรรู้

- prefix มาตรฐาน = `/usr/local` (Intel)
- **อย่า `brew update`** — จะดึงโค้ดจาก upstream ที่อาจปฏิเสธ Intel (`HOMEBREW_NO_AUTO_UPDATE=1` ตั้งให้แล้ว)
- สูตรที่ไม่มี bottle สำหรับ Intel แล้ว (`wget`, `tmux`, `fzf` ฯลฯ) → `brew install` จะพยายาม build จาก source (ช้า) แนะนำ `brew install --force-bottle <formula>` เพื่อให้ล้มเร็วถ้าไม่มี bottle
- สูตรที่แนบมาเป็นไบนารีสำหรับ macOS Intel — ใช้ได้บน macOS รุ่นใหม่กว่า (forward compatible)
- ตัวไบนารี/สูตรมีสัญญาอนุญาตของแต่ละโปรเจกต์ — ดูที่ homepage ของสูตรนั้น ๆ
