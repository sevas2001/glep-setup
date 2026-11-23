#!/usr/bin/env python3
"""TTS de Cartesia para Hermes (provider tipo `command`).

Uso: cartesia_tts.py <texto.txt> <salida.wav>
Lee CARTESIA_API_KEY (y opcional CARTESIA_VOICE_ID) del entorno o del .env del perfil
indicado en HERMES_PROFILE (por defecto "glep"). Nunca imprime la clave.
"""
import json, os, sys, urllib.request

DEFAULT_VOICE = "35b2cfc1-e6fb-4d69-a598-c1780612be4a"


def leer_env():
    vals = {k: os.environ[k] for k in ("CARTESIA_API_KEY", "CARTESIA_VOICE_ID") if k in os.environ}
    if "CARTESIA_API_KEY" in vals:
        return vals
    base = os.environ.get("HERMES_HOME") or os.path.join(os.environ.get("LOCALAPPDATA", os.path.expanduser("~")), "hermes")
    env = os.path.join(base, "profiles", os.environ.get("HERMES_PROFILE", "glep"), ".env")
    for linea in open(env, encoding="utf-8"):
        if "=" in linea and not linea.lstrip().startswith("#"):
            k, v = linea.split("=", 1)
            if k.strip() in ("CARTESIA_API_KEY", "CARTESIA_VOICE_ID"):
                vals[k.strip()] = v.strip()
    return vals


def main():
    entrada, salida = sys.argv[1], sys.argv[2]
    texto = open(entrada, encoding="utf-8").read().strip()
    cfg = leer_env()
    cuerpo = {
        "model_id": "sonic-3",
        "transcript": texto,
        "voice": {"mode": "id", "id": cfg.get("CARTESIA_VOICE_ID", DEFAULT_VOICE)},
        "language": "es",
        "output_format": {"container": "wav", "encoding": "pcm_s16le", "sample_rate": 24000},
    }
    req = urllib.request.Request(
        "https://api.cartesia.ai/tts/bytes",
        data=json.dumps(cuerpo).encode(),
        headers={"X-API-Key": cfg["CARTESIA_API_KEY"], "Cartesia-Version": "2025-04-16", "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=60) as r, open(salida, "wb") as f:
        f.write(r.read())


if __name__ == "__main__":
    main()
