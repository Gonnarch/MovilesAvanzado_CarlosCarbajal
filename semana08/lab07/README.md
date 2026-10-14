# Laboratorio 07 — Tablas en UIKit

**Estudiante:** Carlos Daniel Carbajal Durand.  
**Ubicación solicitada:** semana08/lab07. La guía se titula GLAB-S07; se conserva el número del laboratorio dentro de la semana 08 solicitada.

## Abrir y ejecutar

1. Descargar o clonar este repositorio en el Mac.
2. Abrir uno de estos proyectos en Xcode:
   - `01_Profesores/Profesores.xcodeproj`
   - `02_Personas/Personas.xcodeproj`
   - `03_CulturasPeruanas/CulturasPeruanas.xcodeproj`
3. Seleccionar el esquema del mismo nombre y un simulador de iPhone. Pulsar **Cmd + R**.
4. Para un iPhone físico, seleccionar tu equipo de firma en **Signing & Capabilities**. El simulador no requiere un equipo de firma.

Los proyectos usan Swift, UIKit e iOS 15 o posterior. No necesitan paquetes externos ni conexión a internet. `Main.storyboard` contiene la tabla y su celda prototipo; el `UINavigationController` permite volver desde el detalle.

## A — Tabla de profesores

- `Profesor.swift`: clase `NSObject` con nombre, cargo y foto de tipo `UIImage`.
- Siete registros de ejemplo basados en el ejercicio de la guía.
- `Main.storyboard`: tabla ajustada a la zona segura con cuatro constraints; una celda prototipo de estilo **Subtitle** e identificador **celda**.
- Data source y delegate conectados al ViewController desde el Storyboard.
- `numberOfRowsInSection`: retorna la cantidad de profesores.
- `cellForRowAt`: reutiliza la celda y asigna nombre, cargo y foto.
- Imágenes incluidas dentro de `Assets.xcassets`.

Los avatares son ilustraciones de ejemplo; no son fotografías ni retratos reales de los docentes. Los cargos se reproducen como datos del ejercicio y no se presentan como un directorio institucional actualizado.

## B — Tabla personalizada

- Proyecto independiente con `UITableView` y constraints.
- Celda prototipo con `UIImageView` y `UILabel`.
- Clase `PersonasTableViewCell`, módulo correcto e identificador **celda**.
- Outlets `PersonaImagen` y `personaNombre` enlazados desde el Storyboard.
- Cinco personas con imágenes locales.
- Protocolos `UITableViewDelegate` y `UITableViewDataSource` implementados.
- `didSelectRowAt` presenta una alerta con el nombre seleccionado y botón Aceptar.

## Caso — Culturas peruanas

- Pantalla inicial: tabla de Caral, Chavín, Paracas, Nazca, Moche, Wari, Chimú e Inca.
- Cada celda presenta nombre e imagen representativa.
- `Cultura.swift` almacena nombre, región, descripción e identificador de imagen.
- Al tocar una cultura, se pasa el modelo seleccionado a `DetalleCulturaViewController` mediante su inicializador.
- `pushViewController` abre otra pantalla dentro del Navigation Controller.
- El detalle muestra nombre, región, descripción e imagen de la misma cultura.
- El botón Atrás regresa a la lista; la descripción usa scroll y tipografía adaptable.

Las imágenes son ilustraciones didácticas locales de arquitectura, cerámica y geoglifos; no son fotografías de piezas arqueológicas. La guía de práctica pide imágenes representativas y se incluyen como recursos del proyecto.

## Conclusiones

1. Aprendí a utilizar UITableView para mostrar una lista de datos mediante un arreglo de modelos.
2. Comprendí que UITableViewDataSource define la cantidad y el contenido de las filas, mientras UITableViewDelegate responde a la selección del usuario.
3. La reutilización de celdas permite presentar registros sin crear una vista nueva para cada elemento.
4. Una celda personalizada permite combinar imágenes y etiquetas, siempre que su clase, identificador y outlets estén correctamente conectados.
5. Para mostrar el detalle de una cultura, pasé su modelo a otro controlador y utilicé UINavigationController para avanzar y regresar entre pantallas.

## Verificación y evidencias

Se revisan XML, archivos de imágenes, conexiones, membresía de archivos y configuración de los tres proyectos con `python3 verificar.py`.

**Pendiente de ejecutar en Mac:** compilación con Xcode, ejecución en simulador y capturas reales. No se incluyen capturas inventadas ni se afirma que se haya ejecutado iOS en este entorno Linux. Seguir `docs/pruebas.md` para completar las evidencias.
