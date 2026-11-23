# Problemas reales y soluciones

- **`hermes` no se reconoce tras instalar**: cierra y abre la terminal (PATH).
- **El modelo da error de autenticación tras dejar el PC suspendido**: si Hermes toma prestado el login de Claude Code (`auth.adopt_external_logins: true`) los refresh tokens de un solo uso se invalidan entre programas. Solución: `hermes -p <perfil> auth add anthropic` y luego `hermes -p <perfil> config set auth.adopt_external_logins false`.
- **Bot responde con otra personalidad**: ver `docs/telegram.md` (token en el perfil equivocado).
- **`hermes config set tts.providers.…` falla**: añade `--force`.
- **Git-bash y rutas Windows**: los programas nativos reciben rutas `C:/Users/...` con barras normales; usa `cygpath -w` para pasar rutas a `.exe`.
- **Script `.py` con `\n` dentro de comillas se rompe al generarlo desde otra cadena**: usa `chr(10)` y ejecuta el script una vez tras editarlo.
- **Renombrar la carpeta del vault falla ("Device or resource busy")**: cierra Obsidian, el Explorador y la app de Hermes primero.
- **Dos herramientas editando el vault a la vez** (p. ej. Claude Code y el asistente): haz `git status` antes de commitear y añade solo tus ficheros.
