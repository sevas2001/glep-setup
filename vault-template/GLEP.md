# Reglas del vault

Este vault es la memoria extendida del asistente (Hermes). Lo lee y lo escribe siguiendo estas reglas.

## Estructura
- `00-Inbox/` — Entrada rápida. Todo "guarda esto" sin destino claro va aquí y se clasifica después.
- `01-Yo/` — Perfil, objetivos, preferencias, rutinas, salud.
- `02-Proyectos/` — Una carpeta por proyecto ACTIVO (`02-Proyectos/<nombre>/README.md` + notas).
- `03-Areas/` — Temas permanentes sin fecha de fin (Trabajo, Casa, Finanzas...).
- `04-Conocimiento/` — Notas de referencia reutilizables.
- `05-Personas/` — Una nota por persona.
- `06-Diario/` — Una nota por día `AAAA-MM-DD.md`: qué hablamos, decisiones, pendientes.
- `07-Archivo/` — Proyectos terminados o abandonados (se mueven aquí, no se borran).
- `99-Plantillas/` — Plantillas de notas.
- `Tareas.md` — Lista central de pendientes y recordatorios.

## Convenciones
- Nombres de archivo en minúsculas con guiones: `estacion-meteo.md`.
- Enlazar con wikilinks `[[nota]]`.
- Frontmatter mínimo: `tipo`, `creado`, `tags`.
- Tareas con checkbox: `- [ ] tarea 📅 AAAA-MM-DD`.
- Nunca borrar notas: archivar en `07-Archivo/`.
- Nunca guardar contraseñas ni claves en el vault.
- Al final de cada conversación relevante, añadir resumen al diario del día.
- El gestor de tareas está en `02-Proyectos/gestor-tareas/` (`tareas.json` es la fuente de verdad; tras editarla, `python build.py`).
