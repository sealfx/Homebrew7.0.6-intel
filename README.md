# Homebrew 7.0.6 — Intel portable kit (+ สูตรพื้นฐาน)

ชุดติดตั้ง Homebrew สำหรับ Mac **Intel** ใช้เมื่อ installer ทางการปฏิเสธ:

```bash
# On macOS, support Apple Silicon only
if [[ "${UNAME_MACHINE}" != "arm64" ]]; then
  abort "Homebrew on macOS is only supported on Apple Silicon processors!"
fi
```

ตัวไบนารีอยู่ใน **[Releases](../../releases)** (repo นี้เก็บเฉพาะสคริปต์/เอกสาร เพื่อ clone เร็วและไม่มีไฟล์ใหญ่)

## ดาวน์โหลด

| ไฟล์ | ขนาด | ลิงก์ |
|---|---|---|
| brew 7.0.6 | ~27 MB | [`Homebrew7.0.6-intel.tar.gz`](../../releases/latest/download/Homebrew7.0.6-intel.tar.gz) |
| สูตรพื้นฐาน ~37 สูตร | ~50 MB | [`Cellar7.0.6-intel-basics.tar.gz`](../../releases/latest/download/Cellar7.0.6-intel-basics.tar.gz) |

สำเนาในวง LAN: `http://rakguitar.local/Homebrew7.0.6-intel/`

## ติดตั้ง (คำสั่งเดียว)

```bash
curl -LO https://github.com/sealfx/Homebrew7.0.6-intel/releases/latest/download/Homebrew7.0.6-intel.tar.gz
curl -LO https://github.com/sealfx/Homebrew7.0.6-intel/releases/latest/download/Cellar7.0.6-intel-basics.tar.gz
curl -LO https://raw.githubusercontent.com/sealfx/Homebrew7.0.6-intel/main/install-brew-intel.sh
bash install-brew-intel.sh
```

ตัวเลือก: `SKIP_CELLAR=1` (เอาแค่ brew) · `PREFIX=/opt/brew` (เปลี่ยนที่ติดตั้ง)

สคริปต์จะ: สำรอง brew เดิม → แตกไฟล์ → symlink → ติดตั้ง Cellar ที่แนบมา + `brew link` → ตั้ง PATH → ปิด `HOMEBREW_NO_AUTO_UPDATE`

## สูตรที่แนบมา (~37)

jq · curl · openssl@3 · sqlite · readline · ncurses · pcre2 · simdjson · ncdu · tree · ripgrep · fd · bat · htop · syncthing · lz4 · xz · zstd · brotli · gmp · libssh2 · libnghttp2/3 · libpsl · autoconf · automake · libtool · m4 …
**ไม่แนบ (ใหญ่ ~660 MB):** `go` · `python@3.12` · `python@3.14` · `cmake` — ติดตั้งเพิ่มด้วย brew ได้

ดูรายการเต็มใน [`FORMULAE.txt`](FORMULAE.txt)

## ข้อควรรู้

- prefix มาตรฐาน `/usr/local` (Intel) · **อย่า `brew update`** (upstream อาจดึงโค้ดที่ไม่รองรับ Intel)
- สูตรที่ไม่มี bottle สำหรับ Intel (`wget` · `tmux` · `fzf`) → ใช้ `brew install --force-bottle` เพื่อให้ล้มเร็วถ้าไม่มี bottle
- ไบนารีที่แนบมาใช้ได้บน macOS รุ่นใหม่กว่า (forward compatible)
- Homebrew และแต่ละสูตรมีสัญญาอนุญาตของตัวเอง — ดู [`LICENSE.txt`](LICENSE.txt) และหน้า homepage ของสูตรนั้น ๆ
