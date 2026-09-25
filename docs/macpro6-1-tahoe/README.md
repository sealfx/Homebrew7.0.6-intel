# Mac Pro 2013 (MacPro6,1) บน macOS 26 Tahoe — GPU + USB

รายงานผลการสืบสวนและทดลองจริงบนเครื่อง `rak.local` (macOS 26.7 / 25G229)
เรื่องการ์ดจอ AMD FirePro D500 ×2 (GCN 1.0 · 0x679e) และคอนโทรลเลอร์ USB Fresco Logic FL1100 (0x1b73:0x1100)

**เปิดไฟล์รายงาน:** [`macpro6-1-tahoe-gpu-usb-report.html`](./macpro6-1-tahoe-gpu-usb-report.html) — ไฟล์เดียวจบ ไม่ต้องต่ออินเทอร์เน็ต

## สรุปสั้น

| ส่วน | สถานะบน Tahoe | เหตุผลราก |
|---|---|---|
| การ์ดจอ GCN 1.0 (D500 ×2) | ไม่มีการเร่งความเร็ว | `AMDRadeonX4000.kext` ไม่มี PCI ID `679e` (Apple ถอดโค้ด Tahiti) → WindowServer ล้ม |
| USB 3.0 FL1100 | พอร์ตไม่ทำงาน | ไดรเวอร์จับคู่ได้ แต่ init ~1 ms และไม่สร้างพอร์ต → ไม่มีอุปกรณ์ใด enumerate |
| WiFi + Audio | **patch สำเร็จ** | OCLP-Mod 3.1.9 (BCM Wi-Fi + AppleHDA) |

เครื่องมือที่ทดลอง: OCLP 2.5.1 ✗ · OCLP-R 3.1.5/3.1.8 ✗ (บั๊ก `kdk_api_link = ""`) · **OCLP-Mod 3.1.9 ✓ (ได้แค่ WiFi/Audio)** · OCLP-Plus 3.2.2 ✗ (archive แล้ว)
