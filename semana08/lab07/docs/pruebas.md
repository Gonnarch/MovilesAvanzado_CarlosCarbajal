# Pruebas y capturas en Xcode

Las siguientes pruebas están preparadas para ejecutarse en un Mac; su resultado en simulador aún no está registrado.

| Proyecto | Acción | Resultado esperado | Captura sugerida |
|---|---|---|---|
| Profesores | Ejecutar | Siete profesores con nombre, cargo e imagen | 01_profesores.png |
| Profesores | Abrir Main.storyboard | Celda Subtitle, Identifier celda, dataSource y delegate conectados | 02_conexiones.png |
| Personas | Ejecutar | Cinco personas con imagen y nombre | 03_personas.png |
| Personas | Tocar Juan León | Alerta con su nombre; Aceptar la cierra | 04_alerta.png |
| CulturasPeruanas | Ejecutar | Ocho culturas con imagen y nombre | 05_culturas.png |
| CulturasPeruanas | Tocar Inca | Nombre Inca, región Cusco, descripción e imagen | 06_detalle_inca.png |
| CulturasPeruanas | Volver y tocar Nazca | Detalle diferente correspondiente a Nazca | 07_detalle_nazca.png |
| CulturasPeruanas | Girar dispositivo y aumentar texto | Detalle desplazable sin contenido recortado | 08_accesibilidad.png |

Guardar las capturas reales en `docs/evidencias/` y agregarlas al repositorio después de ejecutar.

Desde Terminal en la carpeta lab07 también se puede compilar para simulador:

```bash
xcodebuild -project 01_Profesores/Profesores.xcodeproj -scheme Profesores -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build
xcodebuild -project 02_Personas/Personas.xcodeproj -scheme Personas -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build
xcodebuild -project 03_CulturasPeruanas/CulturasPeruanas.xcodeproj -scheme CulturasPeruanas -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build
```
