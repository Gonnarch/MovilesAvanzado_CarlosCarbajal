# Requerimientos — Laboratorio 06

**Autor:** Carlos Daniel Carbajal Durand. **Curso:** Programación en Móviles Avanzado. **Semana:** 06.

## Objetivo y alcance

Construir un proyecto UIKit editable en Storyboard para practicar iconos, Navigation Controller, segues Show, presentación modal y paso de datos entre controladores con modelos propios. Incluir la calculadora de venta a plazos y la documentación solicitada.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Mostrar un icono personalizado. | Al instalar la app se ve el astronauta del ZIP proporcionado, distinto al logo de TECSUP. |
| RF02 | Mostrar PANTALLA 1. | La vista inicial contiene el UILabel PANTALLA 1. |
| RF03 | Mostrar PANTALLA 02. | La segunda vista contiene el UILabel PANTALLA 02 y usa ViewController2. |
| RF04 | Navegar con Navigation Controller. | A Pantalla 2 es un Bar Button Item con segue Show; la barra permite regresar. |
| RF05 | Registrar datos del cliente. | Se pueden ingresar apellidos, nombres y DNI en tres UITextField. |
| RF06 | Construir ClienteModel. | Tiene Codigo, Apellido, Nombre y Dni, con inicializadores vacío y parametrizado. |
| RF07 | Presentar confirmación modal. | Continuar instancia ViewControllerConfirmacion por Storyboard ID, asigna pCliente y presenta la pantalla. |
| RF08 | Mostrar los datos recibidos. | Los UILabel tfApellido, tfNombre y tfDni reflejan lo ingresado. |
| RF09 | Cerrar la confirmación. | Cerrar vuelve al formulario sin eliminar sus entradas. |
| RF10 | Validar el cliente. | Rechaza nombres vacíos y DNI que no tenga exactamente 8 dígitos. |
| RF11 | Recoger una nueva venta. | Hay cinco UITextField con sus etiquetas para electrodoméstico, precio, cantidad, meses y tasa mensual. |
| RF12 | Calcular la venta. | Obtiene subtotal, IGV, base, intereses, total y cuota con el supuesto de interés simple documentado. |
| RF13 | Construir y pasar VentaModel. | Las seis salidas son Double y pasan mediante prepare(for:sender:). |
| RF14 | Navegar al resultado. | Calcular tiene un segue Show identificado como showResultado. |
| RF15 | Mostrar seis importes en soles. | Resultado presenta cada salida usando S/. y dos decimales. |
| RF16 | Validar la venta. | Rechaza vacíos, precio/cantidad/meses no positivos, cantidades o meses no enteros, tasa negativa y desbordamientos. |
| RF17 | Ejecutar la actividad modal separada. | El esquema Semana06_02 inicia directamente en el formulario de cliente. |

## Requerimientos no funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RNF01 | Usar Swift y UIKit. | Las vistas se editan en Storyboard y usan UIViewController. |
| RNF02 | Respetar los conceptos hasta semana 6. | Usa clases, UINavigationController, IBOutlet/IBAction y prepare(for:sender:); no incorpora Combine ni Codable. |
| RNF03 | Funcionar sin servicios externos. | Los datos viven en memoria; no hay persistencia, backend ni paquetes externos. |
| RNF04 | Mantener el trabajo ordenado. | Fuentes y documentación permanecen dentro de Semana06/laboratorio06. |
| RNF05 | Conservar la progresión de cambios. | Los commits tienen descripciones concretas para proyecto, icono, navegación, modal, calculadora y documentación. |
| RNF06 | Mantener pantallas legibles. | Auto Layout y desplazamiento vertical permiten ver el contenido en distintos tamaños; se debe verificar en simulador. |
| RNF07 | Documentar la intervención de IA. | PROMPTS.md incluye Contexto, Tarea, Restricciones, Formato, Ejemplo y reflexión. |
| RNF08 | Documentar resultados y límites. | Incluye conclusiones, fórmulas, requerimientos, pruebas y tareas pendientes sin inventar evidencias. |
| RNF09 | Preparar iconos para iOS. | El catálogo identifica los tamaños correctos y los PNG no tienen canal alfa. |
| RNF10 | Permitir reproducción en Xcode. | Hay esquemas compartidos para laboratorio06 y Semana06_02, configurados para iOS 15 o posterior. |

## Supuestos

El PDF remite a unas fórmulas anteriores que no aparecen en el archivo suministrado. Se utiliza IGV del 18 % e interés simple mensual sobre el monto base. La tasa 2 representa 2 %. La moneda se muestra en soles con el formato pedido. Las normas del aula, el trabajo en pareja y la reflexión de tiempos corresponden al estudiante.

## Fuente

[Guía completa del laboratorio](Guia-laboratorio06.pdf), conservada con sus imágenes. Las fuentes oficiales de UIKit y Swift están en CONCLUSIONES.md.
