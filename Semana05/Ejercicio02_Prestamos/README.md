# Calculadora de préstamos
Carlos Carbajal · Programación en Móviles Avanzado · Semana 05

Proyecto iOS independiente en Swift + UIKit. La interfaz está en **Main.storyboard**, con UILabel, UITextField, UIButton, IBOutlet e IBAction. Auto Layout y UIScrollView permiten rotación y pantallas pequeñas.

## Abrir y ejecutar
1. En una Mac con Xcode 15 o posterior, abrir `CalculadoraPrestamos.xcodeproj`.
2. Seleccionar el esquema `CalculadoraPrestamos` y un simulador iPhone con iOS 15 o posterior.
3. Ejecutar con Product > Run. Para dispositivo físico, seleccionar tu equipo de firma en Signing & Capabilities.
4. Abrir `CalculadoraPrestamos/Main.storyboard` para inspeccionar controles y conexiones con `ViewController.swift`.

## Cálculo
P = capital; r = tasa anual / 100 / 12; n = años × 12.
M = P × r × (1+r)^n / ((1+r)^n - 1).
Total = M × n. Intereses = total - P.
La implementación usa una transformación algebraica con log1p/expm1 para evitar pérdida de precisión en tasas pequeñas. Si la tasa es cero, M = P/n.
Se admiten plazos de 1 a 1200 meses completos (hasta 100 años); por ejemplo, 0.5 años son 6 meses. Los importes usan la misma moneda que el capital, sin asumir una divisa.
El total se calcula sin redondear la cuota intermedia, como pide la guía; la pantalla muestra dos decimales. No se agregan seguros, comisiones ni cronogramas de pagos.

## Prueba manual
Capital 10000, tasa 12%, plazo 1 año → **cuota 888.49; total 10661.85; intereses 661.85; 12 cuotas**.
Capital 1200, tasa 0%, plazo 1 año → **cuota 100.00; total 1200.00; intereses 0.00**.

Probar campos vacíos, texto, cero y negativos; debe aparecer un error sin cerrarse la app. Se acepta coma o punto decimal. El botón Listo cierra el teclado. Girar el simulador y comprobar que se pueden ver todos los campos y el resultado desplazando la pantalla.

## Pruebas automatizadas
Desde esta carpeta en una Mac con Swift: `sh Tests/run.sh`.
Prueban directamente Calculator.swift, separado de UIKit.
Compilación de la app: `xcodebuild -project CalculadoraPrestamos.xcodeproj -scheme CalculadoraPrestamos -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build`.

## Estado de verificación
Se revisaron estructura, XML, referencias, conexiones y valores de referencia en Windows. **No se ejecutaron Xcode, el simulador ni las pruebas Swift en este equipo**. Las capturas reales deben obtenerse después de ejecutar en una Mac; no se incluyen capturas simuladas.

## Seis commits de este ejercicio
1. Proyecto UIKit con Storyboard.
2. Modelo de cálculo y validación.
3. Formulario, Auto Layout y conexiones.
4. Acción del botón, resultados y teclado.
5. Pruebas normales, límites y errores.
6. Documentación y pasos de ejecución.
