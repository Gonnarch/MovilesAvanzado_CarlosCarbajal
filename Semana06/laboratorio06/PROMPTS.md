# PROMPTS — Rama ai-assisted

## Contexto

Soy estudiante de Programación en Móviles Avanzado de Tecsup. Estoy desarrollando el laboratorio 06 con Swift y UIKit. Ya practiqué Navigation Controller, navegación Show, presentación modal y el paso de un ClienteModel entre pantallas. Mi proyecto se llama laboratorio06 y utiliza Storyboard.

## Tarea

Implementa una calculadora de venta a plazos de electrodomésticos con dos pantallas. Nueva Venta debe tener cinco UITextField: nombre del electrodoméstico, precio unitario, cantidad, número de meses y tasa de interés mensual expresada como porcentaje. Resultado debe tener seis UILabel para subtotal, IGV, monto base, intereses totales, total y cuota mensual.

Define `class VentaModel: NSObject` con seis propiedades Double: subtotal, igv, base, intereses, total y cuota. Calcula subtotal como precio por cantidad, IGV como subtotal por 0.18 y base como subtotal más IGV. Usa interés simple: intereses igual a base por tasa dividida entre 100 por meses; total igual a base más intereses; cuota igual a total entre meses. El PDF remite a fórmulas que no aparecen en el archivo: deja explícito este supuesto.

Crea un segue Show desde el botón Calcular hacia Resultado con identifier `showResultado`. Pasa el VentaModel con `prepare(for:sender:)`. Muestra las salidas con `String(format: "S/. %.2f", valor)`. Explica por qué usamos class y cómo cambiaría el comportamiento si usáramos struct.

## Restricciones

Usa UIKit, clases, UINavigationController, Storyboard, IBOutlet/IBAction y prepare(for:sender:). No uses SwiftUI, Combine, Codable, bases de datos ni persistencia. Mantén la misma complejidad del ejercicio anterior. Conserva la navegación y el formulario de cliente. Incluye validación sencilla de datos y evita dividir entre cero.

## Formato

Entrega VentaModel.swift, NuevaVentaViewController.swift, ResultadoViewController.swift, las conexiones de Storyboard y una explicación breve. Las pantallas deben poder editarse en Interface Builder. Documenta las fórmulas y un ejemplo verificable.

## Ejemplo

Entrada: refrigeradora, precio 1000, cantidad 2, 12 meses, tasa mensual 2 %.
Salida: subtotal S/. 2000.00, IGV S/. 360.00, base S/. 2360.00, intereses S/. 566.40, total S/. 2926.40, cuota S/. 243.87.

## Reflexión sobre lo que hizo la IA

La solución usa `guard let` para convertir y validar las entradas antes de navegar, mientras que el ejemplo del formulario en la guía toma directamente los textos. También acepta coma o punto decimal y comprueba que el cálculo no produzca valores infinitos.

El botón Calcular mantiene su segue Show en el Storyboard. Se usa `shouldPerformSegue` para impedir que se abra Resultado con datos inválidos, y `prepare(for:sender:)` para pasar la instancia de VentaModel. Esta comprobación adicional debe revisarse porque no aparece en el ejemplo modal de la guía.

Se usa class para seguir el modelo del laboratorio y compartir una instancia entre controladores. No significa que struct impediría navegar: con una struct compatible también se podrían pasar los datos, pero se copiaría el valor en lugar de compartir una referencia. Una struct no puede heredar de NSObject.

**Reflexión personal pendiente:** después de ejecutar ambos ejercicios, completa en CONCLUSIONES.md el tiempo real que empleaste y qué partes comprendiste por ti mismo.
