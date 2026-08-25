# Local dev — connect app to backend on laptop

## Quick start

**1. Start backend (laptop)**

```bash
cd /mnt/D/projects/mine/backend/what2eat-backend
npm run dev
```

Server runs on `http://127.0.0.1:3000`.

**2. Reverse port (phone or emulator via USB)**

```bash
adb reverse tcp:3000 tcp:3000
```

Run this once per USB reconnect. Phone/emulator `localhost:3000` → laptop `localhost:3000`.

**3. Run Flutter app**

```bash
flutter run
```

Default API URL is `http://127.0.0.1:3000` — works with `adb reverse`. No IP or `--dart-define` needed.

---

## Emulator (without adb reverse)

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

`10.0.2.2` = host machine from Android emulator.

---

## Phone on WiFi (without USB)

Use laptop LAN IP instead of `127.0.0.1`:

```bash
hostname -I   # e.g. 192.168.1.148

flutter run --dart-define=API_BASE_URL=http://192.168.1.148:3000
```

Test in mobile browser: `http://192.168.1.148:3000/health`

---

## Troubleshooting

| Problem | Fix |
|--------|-----|
| Connection timeout | Run `adb reverse tcp:3000 tcp:3000` again |
| Still fails on WiFi | Allow port: `sudo ufw allow 3000` |
| Wrong device | `adb devices` then `adb -s <id> reverse tcp:3000 tcp:3000` |
