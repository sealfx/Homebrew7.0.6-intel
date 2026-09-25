# Homebrew 7.0.6 — Intel (portable kit)

ชุดติดตั้ง Homebrew ที่ใช้งานได้บน Mac **Intel** ในยุคที่ Homebrew ตัดการรองรับ Intel แล้ว

## ทำไมต้องมีชุดนี้

ตัวติดตั้งทางการ (`install.sh`) ปัจจุบันมีเงื่อนไขนี้:

```bash
# On macOS, support Apple Silicon only
if [[ "${UNAME_MACHINE}" != "arm64" ]]; then
  abort "Homebrew on macOS is only supported on Apple Silicon processors!"
fi
```

=> เครื่อง Mac Intel ติดตั้ง Homebrew ใหม่จากทางการไม่ได้อีก
ชุดนี้คือสำเนา brew ที่ติดตั้งและใช้งานได้จริง บันทึกจากเครื่อง Intel (macOS) เพื่อให้ติดตั้งซ้ำได้ในอนาคต

## สิ่งที่อยู่ในชุด

| ไฟล์ | รายละเอียด |
|---|---|
| `Homebrew7.0.6-intel.tar.gz` | brew tree (ไม่มี `.git` — ตั้งใจ เพื่อไม่ให้เผลอ `brew update` ไปเป็นตัวที่ไม่รองรับ Intel) |
| `install-brew-intel.sh` | สคริปต์ติดตั้ง (สำรองของเดิม + แตกไฟล์ + symlink + PATH + ปิด auto-update) |
| `VERSION.txt` | เวอร์ชัน/commit/วันที่บันทึก |
| `LICENSE.txt` | สัญญาอนุญาตของ Homebrew (BSD-2-Clause) |

## วิธีใช้

```bash
tar xzf Homebrew7.0.6-intel.tar.gz -C /tmp          # หรือแตกที่ไหนก็ได้
cd /tmp/Homebrew7.0.6-intel 2>/dev/null || cd .
bash install-brew-intel.sh
```

หรือแตกทับเอง:
```bash
sudo tar xzf Homebrew7.0.6-intel.tar.gz -C /usr/local
sudo ln -sfn ../Homebrew/bin/brew /usr/local/bin/brew
```

## หลังติดตั้ง

```bash
eval "$(/usr/local/bin/brew shellenv)"     # ใส่ใน ~/.zprofile เพื่อให้ถาวร
export HOMEBREW_NO_AUTO_UPDATE=1           # แนะนำ: กัน brew อัปเดตตัวเอง
brew --version
brew install <formula>
```

## ข้อควรรู้

- prefix คือ `/usr/local` (มาตรฐานของ Intel) — ย้ายไปที่อื่นได้ด้วย `PREFIX=/path`
- **อย่า `brew update`** — จะดึงโค้ดใหม่จาก upstream ที่อาจปฏิเสธ Intel
- ถ้า OS ใหม่มากจน brew ไม่รู้จัก อาจต้องรอเวอร์ชันใหม่ หรือใช้ `HOMEBREW_DEVELOPER=1`
- Homebrew เป็นซอฟต์แวร์โอเพนซอร์ส (BSD-2-Clause) — ดู `LICENSE.txt`
