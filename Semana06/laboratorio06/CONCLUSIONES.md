# Conclusiones e investigación

## 1. ¿Cuándo conviene usar Show y cuándo Present Modally?

Show conviene cuando la siguiente pantalla continúa el recorrido actual. Dentro de un Navigation Controller, agrega la pantalla a la pila y permite regresar con el botón de la barra. Por ejemplo, en una tienda usaría Show para pasar de la lista de productos al detalle de un producto.

Present Modally conviene para una tarea temporal que se presenta sobre la pantalla actual y que después se cierra. Por ejemplo, usaría una ventana modal para confirmar los datos de un cliente antes de continuar. En este laboratorio, la confirmación se abre con present y se cierra con dismiss.

## 2. ¿Para qué sirven Show Detail y Present As Popover?

Show Detail permite que el contenedor decida cómo mostrar el detalle. Tiene especial sentido en un UISplitViewController: en un iPad puede mostrar el contenido en la columna de detalle, junto a una lista. En un iPhone o un entorno compacto puede adaptarse a una navegación en una sola columna.

Present As Popover muestra contenido temporal anclado a un botón o una vista. Tiene especial sentido en iPad y en entornos de ancho regular; por ejemplo, un selector de opciones asociado al botón de un calendario. En entornos compactos puede adaptarse a una presentación modal. Para usarlo hay que configurar correctamente el punto de anclaje.

## 3. ¿Qué pasaría si ClienteModel o VentaModel fueran struct?

El paso de datos hacia adelante seguiría funcionando si se cambian las declaraciones, los inicializadores y las propiedades receptoras de manera coherente. Una struct no hereda de NSObject y se maneja como un valor. Una class se maneja como una referencia: ambos controladores pueden conservar la misma instancia y observar cambios en ella. Con struct, una modificación de la copia en la segunda pantalla no modificaría automáticamente el valor conservado en la primera.

Por eso se usaron clases en esta entrega: es el patrón solicitado y permite practicar referencias. No se usaron porque fueran la única manera de enviar información.

## 4. Diferencia entre resolver el Ejercicio 2 manual y el Ejercicio 4 con IA

La guía denomina manual al ejercicio de cliente y solicita usar IA en la calculadora. Esta entrega fue preparada con ayuda de IA; no sería correcto afirmar que el estudiante completó el registro manualmente ni inventar tiempos personales.

Después de practicar en Xcode, completa esta respuesta con tu experiencia real:

```text
Tiempo del ejercicio de cliente: __________
Tiempo de la calculadora con IA: __________
Lo que comprendí mejor al hacerlo manualmente: __________
Lo que la IA facilitó: __________
Lo que tuve que revisar para entender la solución: __________
```

## Investigación de la primera parte

**Cambio al insertar Navigation Controller:** se incorpora una barra de navegación y un Navigation Item para la primera pantalla. El área disponible se adapta a esa barra; la pantalla continúa siendo el contenido del controlador y conserva sus controles.

**¿Para qué sirve UINavigationController?** Administra una pila de controladores, la barra de navegación y las transiciones para avanzar y regresar. La pantalla nueva se agrega mediante push y se quita al regresar mediante pop.

**Opciones de segue:** Show continúa el recorrido según el contenedor; Show Detail presenta el detalle según el contenedor; Present Modally presenta una pantalla sobre la actual; Present As Popover presenta contenido temporal anclado en entornos que lo permiten.

## Fuentes oficiales

- Apple, tipos de segue y presentación: https://developer.apple.com/documentation/uikit/customizing-the-behavior-of-segue-based-presentations
- Apple, uso de segues: https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/UsingSegues.html
- Apple, contenido temporal en un popover: https://developer.apple.com/documentation/uikit/displaying-transient-content-in-a-popover
- Swift, clases y estructuras: https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html

El alcance de la entrega es el software y la documentación. La guía también exige revisar el material de la semana, trabajar en pareja y cumplir las normas del aula; esas actividades personales no se pueden certificar desde este proyecto.
