# Instrucciones para Claude Code: instalar Glep end-to-end

Objetivo: dejar al usuario hablando por Telegram con su asistente (Hermes Agent, perfil `glep`), con un vault de Obsidian como memoria y el ToDoApp conectado.

## Reglas
- Habla en el idioma del usuario. Haz las fases en orden y **verifica al final de cada una** antes de seguir.
- **Nunca** pidas, imprimas ni guardes en el chat tokens o claves. Los secretos se escriben en el `.env` del perfil con `scripts/set-secret.ps1` (cuadro de diálogo local) y se comprueban solo con el código HTTP de una llamada de prueba.
- No subas nada con secretos a GitHub. No toques perfiles de Hermes que no sean el que creas aquí.
- Antes de crear un repo en GitHub o instalar algo global, di qué vas a hacer.
- Si un paso falla, dilo, busca otra vía y no inventes resultados.

## Variables que vas a fijar al empezar
Pregunta al usuario (una sola vez, con valores por defecto):
- `PROFILE` = nombre del perfil de Hermes (por defecto `glep`) y nombre del asistente (por defecto el mismo).
- `VAULT` = ruta del vault (por defecto `%USERPROFILE%\Jarvis`, o la que prefiera).
- `USER_NAME` = cómo quiere que le llame el asistente.
- ¿Quiere voz (notas de voz)? sí/no.

## Fase 0 · Comprobaciones previas
```powershell
git --version; python --version; gh --version
```
Si falta algo, instálalo con `winget` (`winget install Git.Git Python.Python.3.12 GitHub.cli`) y reabre la terminal.

## Fase 1 · Instalar Hermes Agent
Windows nativo (PowerShell): `scripts/01-install-hermes.ps1` (ejecuta `iex (irm https://hermes-agent.nousresearch.com/install.ps1)`).
Linux/macOS/WSL2: `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`.

Comprobación: `hermes --version` imprime una versión.

## Fase 2 · Modelo (login del proveedor)
Esto necesita al usuario (abre navegador):
```
hermes model                       # elegir proveedor y modelo
hermes -p <PROFILE> auth add anthropic   # si usa cuenta de Claude
```
Comprobación: `hermes -p <PROFILE> chat --oneshot -Q -q "responde solo: ok"` devuelve `ok`.

## Fase 3 · Perfil
```
hermes profile create <PROFILE> --description "Asistente personal"
```
Después copia `profile/SOUL.md.template` a `<HERMES_HOME>/profiles/<PROFILE>/SOUL.md` sustituyendo `{{ASSISTANT_NAME}}`, `{{USER_NAME}}` y `{{VAULT_PATH}}`.
Localiza `<HERMES_HOME>` con `hermes -p <PROFILE> profile show` (en Windows suele ser `%LOCALAPPDATA%\hermes\profiles\<PROFILE>`).

## Fase 4 · Vault de Obsidian
```powershell
./scripts/02-create-vault.ps1 -VaultPath "<VAULT>" -UserName "<USER_NAME>"
```
Copia `vault-template/` al destino, hace `git init` y el primer commit.
Luego registra la ruta para el asistente:
```
scripts/set-secret.ps1 -Profile <PROFILE> -Name OBSIDIAN_VAULT_PATH -Plain "<VAULT con barras />"
```
(la ruta no es un secreto, por eso se permite `-Plain`.)
Dile al usuario que abra Obsidian con **"Abrir una carpeta como bóveda"** (no "Crear bóveda").

## Fase 5 · ToDoApp
```
git clone https://github.com/sevas2001/todoapp "<VAULT>/02-Proyectos/gestor-tareas"
cd "<VAULT>/02-Proyectos/gestor-tareas" && python build.py
```
Debe terminar con `OK:`. `tareas.json` es la fuente de verdad; el asistente la edita y ejecuta `build.py`. Quita la carpeta `.git` interna si quieres que el vault la versione como parte suya.
Pide al usuario sus tareas reales y sustituye las de ejemplo.

## Fase 6 · Telegram (ver `docs/telegram.md`)
1. El usuario crea el bot con **@BotFather** (`/newbot`) y consigue el token. Opción más fácil: dashboard/desktop de Hermes → Messaging → Telegram → *Create with QR*.
2. Token y tu ID: `scripts/set-secret.ps1 -Profile <PROFILE> -Name TELEGRAM_BOT_TOKEN` (te abre un cuadro; el usuario pega el token). Después `-Name TELEGRAM_ALLOWED_USERS -Plain "<id numérico>"` y `-Name TELEGRAM_HOME_CHANNEL -Plain "<id numérico>"`.
   - ID numérico: el usuario escribe a **@userinfobot** en Telegram.
3. Arranca: `hermes -p <PROFILE> gateway restart --yes` (o `hermes gateway setup` la primera vez).
4. Comprobación: `hermes gateway status` muestra el perfil activo, y el usuario escribe "hola" al bot y recibe respuesta.

## Fase 7 · Voz (opcional, `docs/voice.md`)
Solo si el usuario la quiere. Claves `GROQ_API_KEY` (STT) y `CARTESIA_API_KEY` (TTS) con `set-secret.ps1`, copiar `voice/cartesia_tts.py` a `~/.glep/` y aplicar `profile/config.snippet.yaml`. Probar enviando una nota de voz al bot.

## Fase 8 · Verificación final
```powershell
./scripts/verify.ps1 -Profile <PROFILE> -VaultPath "<VAULT>"
```
Comprueba: Hermes, perfil, SOUL, vault con git, ToDoApp, gateway y claves presentes (sin mostrarlas). Informa al usuario de lo que pasa y de lo que no.

## Al terminar
- Añade a `Tareas.md` del vault lo pendiente (backup del vault a GitHub **privado**, rotar claves, arranque automático del gateway).
- No subas el vault a un repo público.
