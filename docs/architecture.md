# Arquitectura

## Piezas
1. **Hermes Agent**: el agente (CLI, app de escritorio, gateway de mensajería). Se instala una vez; cada asistente es un **perfil**.
2. **Perfil** (`hermes profile create glep`): carpeta con su propia config, claves, personalidad y memoria.
3. **Vault de Obsidian**: carpeta de Markdown con git. Es la memoria larga del asistente (perfil del usuario, proyectos, diario, tareas).
4. **ToDoApp**: `tareas.json` → `build.py` → `index.html` (grafo de dependencias). Vive dentro del vault.
5. **Gateway**: proceso que conecta Hermes con Telegram (y otros). Usa *long polling*: sale él a Telegram, no hace falta abrir puertos.
6. **Voz (opcional)**: STT (Groq Whisper) para entender notas de voz; TTS (Cartesia) para contestar con voz.

## Dónde vive cada cosa (Windows)
```
%LOCALAPPDATA%\hermes\                       instalación y perfil "default"
%LOCALAPPDATA%\hermes\profiles\<perfil>\
    config.yaml        configuración (modelo, tts, stt, auth…)
    .env               CLAVES (TELEGRAM_*, GROQ_*, CARTESIA_*, OBSIDIAN_VAULT_PATH)  ← secreto
    SOUL.md            personalidad
    memories/          memoria corta que Hermes inyecta en cada sesión
    skills/            procedimientos reutilizables
    state.db           historial de sesiones
<VAULT>\                                      el vault (git)
    GLEP.md            reglas de organización para el asistente
    Tareas.md          pendientes
    02-Proyectos\gestor-tareas\              ToDoApp
~/.glep/                                       scripts de voz (opcional)
```

## Cómo se conectan
- **Hermes ↔ vault**: la ruta está en `OBSIDIAN_VAULT_PATH` (en el `.env` del perfil) y `SOUL.md` le dice que lo lea (`GLEP.md` primero) y lo escriba siguiendo esas reglas. Usa sus herramientas de ficheros y git; no hay plugin de Obsidian.
- **Hermes ↔ ToDoApp**: el asistente edita `tareas.json` y ejecuta `python build.py`. El usuario abre `index.html` o `python build.py --serve` (http://localhost:8765).
- **Hermes ↔ Telegram**: `TELEGRAM_BOT_TOKEN` + `TELEGRAM_ALLOWED_USERS` en el `.env` del perfil; el gateway arranca el adaptador. Un token solo puede estar en un gateway a la vez.
- **Memoria en dos niveles**: `memories/` (pequeña, siempre cargada: quién es el usuario, entorno) y el vault (grande, se abre bajo demanda).

## Perfiles y gateway
Si hay varios perfiles, un gateway "multiplexor" del perfil `default` puede servirlos a todos. Tras cambiar el `.env` de un perfil: `hermes -p <perfil> gateway restart --yes`. El reinicio se niega si hay sesiones vivas; prográmalo con retraso si lo lanza el propio asistente.

## Flujo de un mensaje
Móvil → Telegram → gateway (polling) → comprobación de ID permitido → sesión del perfil → modelo (+ herramientas: ficheros del vault, terminal, web) → respuesta → Telegram. Una nota de voz pasa antes por STT; si hay TTS, la respuesta se convierte a opus y se envía como nota de voz.
