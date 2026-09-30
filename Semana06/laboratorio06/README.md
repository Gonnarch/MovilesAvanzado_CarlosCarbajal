# Laboratorio 06 — UIKit, navegación y ventanas modales

**Estudiante:** Carlos Daniel Carbajal Durand  
**Proyecto:** laboratorio06  
**Tecnologías:** Swift, UIKit, Storyboard y Auto Layout  
**Compatibilidad configurada:** iOS 15 o posterior, iPhone e iPad; Xcode 15 o posterior.

## Abrir y ejecutar

1. Descomprime `laboratorio06.zip`.
2. Abre `laboratorio06.xcodeproj`, ubicado dentro de la carpeta `laboratorio06`.
3. En la barra superior de Xcode selecciona el esquema **laboratorio06**.
4. Selecciona un simulador iPhone instalado; evita seleccionar “Any iOS Device”.
5. Presiona **⌘R**.
6. Para la app modal independiente, selecciona el esquema **Semana06_02** y ejecuta de nuevo.

El simulador no requiere seleccionar un equipo de firma. Para un iPhone físico, selecciona tu Team en **Signing & Capabilities** para el target correspondiente. No necesita paquetes externos ni conexión a Internet para funcionar.

## Primera parte: icono y navegación

- Se incluyó el astronauta del ZIP `Hotpot Design (2)(1).zip`, distinto al logo de TECSUP.
- `Assets.xcassets/AppIcon.appiconset` contiene las resoluciones recibidas y un `Contents.json` nuevo que las asigna a iPhone, iPad y App Store.
- Las imágenes del icono se guardaron sin canal alfa para ser compatibles con el catálogo de iconos de iOS. El dibujo original se conserva.
- `Logo.imageset` contiene también la imagen para mostrarla en PANTALLA 1.
- `Main.storyboard` tiene un Navigation Controller como controlador inicial.
- PANTALLA 1 tiene la clase `ViewController` y un Bar Button Item **A Pantalla 2**.
- El botón tiene un segue **Show** hacia PANTALLA 02, cuya clase es `ViewController2`.
- UIKit muestra el botón de regreso automáticamente.
- Los dos botones adicionales de PANTALLA 1 permiten abrir los otros ejercicios sin eliminar la navegación solicitada.

## Ventanas modales: Semana06_02

La guía solicita una aplicación llamada `Semana06_02`. Se agregó un segundo target y un segundo esquema con ese nombre, dentro del mismo proyecto para mantener una sola entrega.

- El esquema **Semana06_02** inicia en `Modal.storyboard`.
- El esquema **laboratorio06** también permite acceder al formulario de cliente desde su pantalla inicial.
- El formulario tiene los campos `tfApellido`, `tfNombre`, `tfDni` y el botón **Continuar**.
- `ClienteModel: NSObject` conserva `Codigo`, `Apellido`, `Nombre`, `Dni`, el inicializador vacío y el inicializador con parámetros de la guía.
- El controlador del formulario se llama `ViewControllerCliente`, para evitar confundirlo con el `ViewController` de la primera parte. Cumple el mismo papel del controlador del ejemplo.
- **Continuar** crea un `ClienteModel`, instancia `ViewControllerConfirmacion` mediante su Storyboard ID, le asigna `pCliente` y lo presenta con `present(_:animated:completion:)`.
- La confirmación tiene Custom Class y Storyboard ID `ViewControllerConfirmacion`, y los outlets UILabel `tfApellido`, `tfNombre` y `tfDni`.
- El botón **Cerrar** permite volver al formulario con `dismiss`.
- Se valida que los nombres estén completos y que el DNI tenga 8 dígitos.

## Calculadora de venta a plazos

- **Nueva Venta**: cinco UITextField con UILabel para electrodoméstico, precio, cantidad, meses y tasa mensual.
- El botón **Calcular** tiene el segue **Show** con identifier `showResultado` conectado directamente en el Storyboard.
- `shouldPerformSegue` valida los campos y calcula; `prepare(for:sender:)` pasa el modelo.
- `VentaModel: NSObject` tiene seis propiedades Double: `subtotal`, `igv`, `base`, `intereses`, `total`, `cuota`.
- **Resultado** tiene seis UILabel conectados mediante IBOutlet y formateados con `String(format: "S/. %.2f", valor)`.
- No se usa Combine, Codable ni persistencia.

### Fórmulas y supuesto necesario

El PDF menciona “las fórmulas de arriba”, pero no incluye esas fórmulas en la sección entregada. Se implementó **interés simple mensual** sobre el monto con IGV, con la tasa ingresada como porcentaje (2 significa 2 %):

```text
subtotal = precio unitario × cantidad
igv = subtotal × 0.18
base = subtotal + igv
intereses = base × (tasa mensual / 100) × meses
total = base + intereses
cuota = total / meses
```

Ejemplo: refrigeradora, precio 1000, cantidad 2, meses 12 y tasa 2:

| Resultado | Valor |
| --- | ---: |
| Subtotal | S/. 2000.00 |
| IGV | S/. 360.00 |
| Monto base | S/. 2360.00 |
| Intereses totales | S/. 566.40 |
| Total a pagar | S/. 2926.40 |
| Cuota mensual | S/. 243.87 |

Las operaciones se mantienen como Double y se formatean a dos decimales al mostrarse, como pide la guía. No se genera un cronograma ni se ajusta la última cuota, porque el enunciado solicita seis resultados.

## Documentos y evidencias

- `PROMPTS.md`: prompt CTRFE y reflexión sobre la ayuda de IA.
- `CONCLUSIONES.md`: respuestas a las cuatro preguntas y las investigaciones de la primera parte.
- `docs/Guia-laboratorio06.pdf`: guía completa original, con todas sus imágenes de referencia.
- `docs/EVIDENCIAS.md`: pasos y nombres sugeridos para las capturas reales del simulador.
- `docs/VERIFICACION.md`: alcance de las verificaciones realizadas y pendientes.

No se incluyen capturas simuladas como si fueran evidencias de ejecución: deben tomarse al ejecutar el proyecto en tu Mac.

## Repositorio y organización

Este trabajo se encuentra en `Semana06/laboratorio06` del repositorio [MovilesAvanzado_CarlosCarbajal](https://github.com/Gonnarch/MovilesAvanzado_CarlosCarbajal).

Los commits separan la creación del proyecto, la configuración del icono, la navegación, el registro modal, la calculadora y la documentación. Se conservan los trabajos anteriores del repositorio.

Los requerimientos funcionales y no funcionales se detallan en [docs/requerimientos.md](docs/requerimientos.md), siguiendo la organización del laboratorio de Metro de Lima. El plan de comprobaciones está en [docs/pruebas.md](docs/pruebas.md).

Las ramas existentes `manual` y `ai-assisted` conservan su historial. El avance de navegación y cliente se integra en `manual`, y la solución completa con la calculadora se integra en `ai-assisted`.
