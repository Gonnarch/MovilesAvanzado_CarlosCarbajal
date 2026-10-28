# Semana 10 — actividades SwiftUI y CTS

Carpeta Semana10 solicitada para este repositorio. El material de origen se titula GLAB-S08-JLEONS-2026-2; se conserva su orden de actividades.

## Abrir los proyectos

Cada actividad tiene su propio proyecto Xcode dentro de `Proyecto`. Abre uno de los ocho `.xcodeproj` en Xcode 15 o posterior y usa un simulador iOS 17+. No mezcles sus archivos App en un único target.

1. `01_Proyecto_y_Stacks`: proyecto inicial y VStack/HStack/ZStack.
2. `02_Ventana02`: contenedores combinados.
3. `03_Peso_Ideal`: fórmula académica y validación.
4. `04_Menu_Navegable`: navegación entre las vistas anteriores.
5. `05_Notas`: cuatro notas, elimina una numérica mínima; AN vale 0 y no se elimina.
6. `06_CTS`: proyecto SwiftUI, Excel numérico y requisitos RF/RNF.
7. `07_Instructores`: pago, ONP/AFP, quinta categoría y EsSalud del empleador.
8. `08_Trabajo_Grupal`: cuentas por cobrar y pagar.
9. `09_Conclusiones`: conclusiones.

## CTS: proyecto Swift, Excel y requerimientos

- [Proyecto SwiftUI](06_CTS/Proyecto/CTSPeru.xcodeproj): abre `CTSPeru.xcodeproj` en Xcode 15+ y selecciona un simulador iOS 17+. Las fuentes están en `Proyecto/CTSPeru`.
- [CTS_Automatica.xlsx](06_CTS/CTS_Automatica.xlsx): tablas numéricas con bordes y colores; meses calculados desde las fechas, sin ingreso manual ni párrafos de instrucciones.
- [requerimientos.md](06_CTS/requerimientos.md): objetivo, RF con criterios de aceptación, RNF, exclusiones y fuentes, con la estructura de Metro de Lima.

La carpeta CTS contiene estos tres entregables. El proyecto restaurado conserva sus últimos cambios: período Mayo/Noviembre, asignación familiar, fijos, variables, fechas y gratificación estimada, percibida o histórica. Las demás actividades conservan sus proyectos.

## Verificación

El Excel de CTS se probó con 32 escenarios de recálculo en el motor de hojas disponible, no en Excel de escritorio. Su alcance está en el documento de requerimientos.

Los ocho proyectos, incluido CTS, se revisaron estructuralmente. La compilación de SwiftUI y la ejecución de las pruebas nativas requieren Xcode y siguen pendientes. Las imágenes son vistas de referencia, no capturas del simulador.

`Pruebas_Swift` conserva los modelos y ejemplos de prueba de peso ideal, notas y pago, sin código de CTS. Para ejecutarlos en Mac: `swiftc Modelos.swift main.swift -o pruebas_s08` y `./pruebas_s08`.

Abre `INDICE.html` para recorrer las actividades. Los datos de prueba son ficticios.
