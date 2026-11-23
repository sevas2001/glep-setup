# glep-setup

Receta completa, de cero a bot de Telegram, para montar tu propio asistente personal con **[Hermes Agent](https://hermes-agent.nousresearch.com)** + un vault de **Obsidian** como memoria + un gestor de tareas (**ToDoApp**) + **Telegram** como canal (texto y, opcionalmente, notas de voz).

Está pensado para que se lo des a **Claude Code** y haga la instalación casi entera él solo. Tú solo tienes que hacer 3 cosas a mano (crear el bot en Telegram, iniciar sesión en el proveedor del modelo y pegar claves cuando te las pida un cuadro de diálogo).

> Este repo no contiene datos personales de nadie. Todo lo personal (perfil, tareas, notas) lo pones tú en tu vault.

## Cómo usarlo (30 segundos)

1. Instala [Claude Code](https://docs.claude.com/en/docs/claude-code) y abre una terminal.
2. `git clone https://github.com/sevas2001/glep-setup.git && cd glep-setup`
3. Ejecuta `claude` y dile: **"Lee CLAUDE.md y haz la instalación completa"**.

Claude Code seguirá `CLAUDE.md`, que es la guía paso a paso con comprobaciones en cada fase.

## Qué vas a tener al final

```
 Tu móvil (Telegram)
        │  mensajes / notas de voz
        ▼
 Bot de Telegram (creado con @BotFather)
        │  long polling (no hace falta IP pública ni abrir puertos)
        ▼
 Hermes gateway  ──►  Perfil "glep"  (config.yaml, .env, SOUL.md, skills)
                          │
          ┌───────────────┼────────────────────┐
          ▼               ▼                    ▼
   Modelo (Anthropic   Vault Obsidian      Voz (opcional)
   u otro proveedor)   (git, Markdown)     STT: Groq Whisper
                          │                TTS: Cartesia
                          ▼
                    ToDoApp (tareas.json → build.py → index.html)
```

Detalle en [`docs/architecture.md`](docs/architecture.md).

## Estructura del repo

| ruta | para qué sirve |
|---|---|
| `CLAUDE.md` | Guía para Claude Code: fases, comandos y comprobaciones |
| `docs/architecture.md` | Cómo encaja todo y dónde vive cada cosa en el disco |
| `docs/telegram.md` | Crear el bot y conectarlo (con los fallos típicos) |
| `docs/voice.md` | Módulo opcional de voz (STT + TTS) |
| `docs/troubleshooting.md` | Problemas reales y su solución |
| `vault-template/` | Vault de Obsidian vacío con estructura PARA y reglas (`GLEP.md`) |
| `profile/SOUL.md.template` | Personalidad del asistente (con placeholders) |
| `profile/config.snippet.yaml` | Fragmentos de config (voz) |
| `scripts/` | Instalación, creación del vault, guardado seguro de claves, verificación |
| `voice/cartesia_tts.py` | Script TTS para Hermes (opcional) |

## Requisitos
- Windows 10/11 (los scripts son PowerShell; en Linux/macOS/WSL Claude Code adapta los equivalentes que se indican en `CLAUDE.md`).
- Cuenta de Telegram y acceso a un modelo (cuenta Anthropic / Claude, o una API key de cualquier proveedor que soporte Hermes).
- Git y GitHub CLI (`gh`) si quieres versionar el vault.
- Opcional voz: claves gratuitas de [Groq](https://console.groq.com) (STT) y [Cartesia](https://cartesia.ai) (TTS, plan gratis ~20K caracteres/mes).

## Seguridad
- Las claves viven **solo** en `.env` del perfil de Hermes. Nunca en el vault, nunca en este repo, nunca pegadas en un chat.
- El bot solo responde a tu ID de Telegram (`TELEGRAM_ALLOWED_USERS`).
- Si una clave se filtra: revócala en su proveedor y genera otra.

## Licencia
MIT.
