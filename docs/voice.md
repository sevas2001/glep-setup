# Voz (opcional)

Entender notas de voz (STT) y contestar con voz (TTS).

## STT: Groq Whisper (gratis)
1. Clave en https://console.groq.com → `scripts/set-secret.ps1 -Profile <perfil> -Name GROQ_API_KEY`.
2. `hermes -p <perfil> config set stt.provider groq` y `hermes -p <perfil> config set stt.language es` (cambia `es` por tu idioma; el valor por defecto era `en`).
3. Whisper alucina frases ("Suscríbete al canal", "Gracias") con silencio o ruido. Si un audio no encaja con la conversación, pregunta en vez de actuar.

## TTS: Cartesia
1. Clave en https://cartesia.ai (plan gratis ~20K créditos/mes, ~1 crédito por carácter) → `-Name CARTESIA_API_KEY`. Opcional: `CARTESIA_VOICE_ID` para otra voz.
2. Copia `voice/cartesia_tts.py` a `~/.glep/` (o donde quieras).
3. Añade a `config.yaml` del perfil lo de `profile/config.snippet.yaml` (ajustando rutas). Hermes necesita `hermes config set --force` para claves bajo `tts.providers.*`.
4. `hermes -p <perfil> config set tts.provider cartesia`.
5. Prueba: `hermes -p <perfil> chat --oneshot -Q -q "usa text_to_speech para decir hola"`.

## Notas de voz en Telegram
Hermes envía el audio como nota de voz si es opus. Si generas el audio tú: `ffmpeg -y -i in.wav -c:a libopus -b:a 48k out.ogg`.
En el chat, `/voice tts` activa las respuestas por voz de la sesión.

## Gratis y local (alternativas)
Kokoro-82M o Pocket TTS (CPU) para TTS sin coste; faster-whisper local para STT (`stt.provider local`). Calidad en español algo menor que Cartesia.
