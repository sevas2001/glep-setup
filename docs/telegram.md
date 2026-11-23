# Telegram paso a paso

## Opción A (fácil): QR desde Hermes
Dashboard (`hermes dashboard`) o app de escritorio (`hermes desktop`) → **Messaging → Telegram → Create with QR**. Escanea el código: Hermes crea el bot, detecta tu ID, escribe `TELEGRAM_BOT_TOKEN` y `TELEGRAM_ALLOWED_USERS` en el `.env` del perfil activo y reinicia el gateway.
Ojo: se escribe en el perfil **activo**. Si quieres que sea el de tu asistente, actívalo antes (`hermes profile use <perfil>`) o mueve las líneas `TELEGRAM_*` al `.env` correcto.

## Opción B (manual)
1. En Telegram abre **@BotFather** → `/newbot` → nombre → usuario acabado en `bot`. Te da el token (`123456789:AAA...`).
2. Tu ID numérico: escribe a **@userinfobot**.
3. Guarda en `<HERMES_HOME>/profiles/<perfil>/.env`:
   ```
   TELEGRAM_BOT_TOKEN=...
   TELEGRAM_ALLOWED_USERS=<tu id>
   TELEGRAM_HOME_CHANNEL=<tu id>
   ```
   Usa `scripts/set-secret.ps1` para no pegar el token en ningún chat.
4. `hermes -p <perfil> gateway restart --yes`
5. Abre tu bot en Telegram, pulsa **Start** y escribe "hola".

## Comprobar el token sin exponerlo
```bash
set -a; . "<HERMES_HOME>/profiles/<perfil>/.env"; set +a
curl -s -o /dev/null -w "%{http_code}\n" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getMe"   # 200 = válido
```

## Fallos típicos
- **Responde otro agente / sin tu personalidad**: el token quedó en el `.env` del perfil `default`. Muévelo al del perfil de tu asistente y reinicia.
- **No responde**: `hermes gateway status`; revisa que `TELEGRAM_ALLOWED_USERS` es tu ID numérico (no tu @usuario).
- **Dos gateways con el mismo token**: Telegram devuelve conflicto 409. Deja solo uno.
- **El reinicio se niega**: hay sesiones vivas; `--yes` y reintenta, o prográmalo con unos segundos de retraso.
- **El token salió en un chat/log**: `/revoke` en BotFather y repite.

## Enviar un mensaje desde el asistente (útil para avisos)
```bash
curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d chat_id="$TELEGRAM_HOME_CHANNEL" --data-urlencode text="Hola"
```
(comprueba solo `ok` y `message_id`, no imprimas el token).
