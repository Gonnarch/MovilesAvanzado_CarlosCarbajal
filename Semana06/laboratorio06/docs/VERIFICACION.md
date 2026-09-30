# Verificación de la entrega

## Comprobaciones realizadas

- PBX: 64 objetos, 2 targets, referencias de recursos y fuentes válidas.
- Info.plist: Main y Modal asignados a los esquemas correspondientes.
- Main.storyboard: XML, IDs, outlets y acciones verificados.
- LaunchScreen.storyboard: XML, IDs, outlets y acciones verificados.
- Modal.storyboard: XML, IDs, outlets y acciones verificados.
- Show en Bar Button Item; showResultado en Calcular; ID modal correcto.
- Dos esquemas compartidos enlazados a sus targets.
- 19 asignaciones de iconos: tamaños exactos y sin canal alfa.
- Fórmulas tomadas del Swift: tres casos numéricos correctos, incluida tasa cero.
- Validaciones presentes, prepare(for:) y seis salidas formateadas en soles.
- Guía original preservada íntegramente, incluidas sus imágenes.

## Pendiente de ejecutar en macOS

Este entorno no dispone de Xcode, ibtool ni del simulador de iOS. No se ha compilado, ejecutado ni verificado visualmente la app en un dispositivo Apple. Las comprobaciones anteriores son estáticas; no sustituyen la compilación, la validación del Storyboard por Interface Builder ni la prueba de navegación.

Abre cada esquema en Xcode, ejecuta con ⌘R y sigue docs/EVIDENCIAS.md. Verifica además el diseño en iPhone e iPad y el desplazamiento de los formularios.

La reflexión personal de tiempos queda para el estudiante, sin inventar experiencias. La publicación en GitHub se realiza con commits progresivos dentro de Semana06/laboratorio06.
