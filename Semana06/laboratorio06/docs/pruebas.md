# Plan de pruebas — Laboratorio 06

## Alcance de la verificación realizada

Se revisaron estáticamente los Storyboards, outlets, acciones, referencias del proyecto, esquemas, catálogos y cálculos. Los resultados están en [VERIFICACION.md](VERIFICACION.md). Este entorno no tiene Xcode; las pruebas de compilación y ejecución siguientes deben realizarse en macOS.

## Casos de aceptación en simulador

| Caso | Acción o entrada | Resultado esperado | Estado |
| --- | --- | --- | --- |
| P01 | Ejecutar laboratorio06 y volver al inicio de iOS. | Icono del astronauta instalado. | Pendiente en Xcode |
| P02 | Abrir laboratorio06. | PANTALLA 1 con Navigation Controller. | Pendiente en Xcode |
| P03 | Tocar A Pantalla 2 y regresar. | PANTALLA 02 y retorno a PANTALLA 1. | Pendiente en Xcode |
| P04 | Registrar Carbajal, Carlos, 12345678. | La confirmación modal muestra los tres valores. | Pendiente en Xcode |
| P05 | Cerrar la confirmación y modificar nombre. | Conserva el formulario y muestra el nombre nuevo al continuar. | Pendiente en Xcode |
| P06 | Dejar un nombre vacío o ingresar DNI de 7 dígitos. | Alerta; no se abre la confirmación. | Pendiente en Xcode |
| P07 | Ejecutar Semana06_02. | Inicia en Datos del cliente y presenta la confirmación. | Pendiente en Xcode |
| P08 | Refrigeradora, 1000, 2, 12, 2. | 2000.00; 360.00; 2360.00; 566.40; 2926.40; 243.87, en soles. | Fórmulas verificadas; UI pendiente |
| P09 | Producto, 100, 1, 1, 0. | Intereses 0.00; total y cuota 118.00. | Fórmulas verificadas; UI pendiente |
| P10 | Producto, 250.5, 3, 6, 1.5. | Subtotal 751.50; total 966.58; cuota 161.10. | Fórmulas verificadas; UI pendiente |
| P11 | Usar 250,5 y 1,5 en los campos decimales. | Obtiene el mismo resultado que P10. | Pendiente en Xcode |
| P12 | Ingresar cero meses, cantidad decimal o tasa negativa. | Alerta; no navega a Resultado. | Validación revisada; UI pendiente |
| P13 | Volver de Resultado y calcular con entradas distintas. | Los seis importes corresponden a la venta nueva. | Pendiente en Xcode |
| P14 | Abrir en iPhone e iPad y desplazarse. | Controles legibles, accesibles y sin superposición. | Pendiente en Xcode |

## Capturas

Sigue [EVIDENCIAS.md](EVIDENCIAS.md) para guardar evidencias reales. No se han inventado capturas de una ejecución que no se realizó.
