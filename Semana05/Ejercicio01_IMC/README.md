# Calcular el IMC de una persona
Carlos Carbajal · Programación en Móviles Avanzado · Semana 05

Proyecto iOS independiente en Swift + UIKit. La interfaz está en **Main.storyboard**, con UILabel, UITextField, UIButton, IBOutlet e IBAction. Auto Layout y UIScrollView permiten rotación y pantallas pequeñas.

## Abrir y ejecutar
1. En una Mac con Xcode 15 o posterior, abrir `CalculadoraIMC.xcodeproj`.
2. Seleccionar el esquema `CalculadoraIMC` y un simulador iPhone con iOS 15 o posterior.
3. Ejecutar con Product > Run. Para dispositivo físico, seleccionar tu equipo de firma en Signing & Capabilities.
4. Abrir `CalculadoraIMC/Main.storyboard` para inspeccionar controles y conexiones con `ViewController.swift`.

## Cálculo
IMC = peso / (altura × altura). El resultado se muestra con dos decimales.
Se conservan los límites del ejemplo de la página 19: <18.5 bajo peso, <24.9 peso normal, <29.9 sobrepeso; en caso contrario obesidad. La clasificación usa el valor sin redondear.

## Prueba manual
70 kg y 1.70 m → **IMC: 24.22 - Peso normal**.
Probar 18.5, 24.9 y 29.9 kg con altura 1 m para verificar los límites de la guía.

Probar campos vacíos, texto, cero y negativos; debe aparecer un error sin cerrarse la app. Se acepta coma o punto decimal. El botón Listo cierra el teclado. Girar el simulador y comprobar que se pueden ver todos los campos y el resultado desplazando la pantalla.

## Pruebas automatizadas
Desde esta carpeta en una Mac con Swift: `sh Tests/run.sh`.
Prueban directamente Calculator.swift, separado de UIKit.
Compilación de la app: `xcodebuild -project CalculadoraIMC.xcodeproj -scheme CalculadoraIMC -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build`.

## Estado de verificación
Se revisaron estructura, XML, referencias, conexiones y valores de referencia en Windows. **No se ejecutaron Xcode, el simulador ni las pruebas Swift en este equipo**. Las capturas reales deben obtenerse después de ejecutar en una Mac; no se incluyen capturas simuladas.

## Seis commits de este ejercicio
1. Proyecto UIKit con Storyboard.
2. Modelo de cálculo y validación.
3. Formulario, Auto Layout y conexiones.
4. Acción del botón, resultados y teclado.
5. Pruebas normales, límites y errores.
6. Documentación y pasos de ejecución.
