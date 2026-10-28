# Semana 10 — actividades SwiftUI y CTS

Carpeta Semana10 solicitada para este repositorio. El material de origen se titula GLAB-S08-JLEONS-2026-2; se conserva su orden de actividades.

## Abrir los proyectos

Cada actividad tiene su propio proyecto Xcode dentro de `Proyecto`. Abre uno de los ocho `.xcodeproj` en Xcode 15 o posterior y usa un simulador iOS 17+. No mezcles sus archivos App en un único target.

1. `01_Proyecto_y_Stacks`: proyecto inicial y VStack/HStack/ZStack.
2. `02_Ventana02`: contenedores combinados.
3. `03_Peso_Ideal`: fórmula académica y validación.
4. `04_Menu_Navegable`: navegación entre las vistas anteriores.
5. `05_Notas`: cuatro notas, elimina una numérica mínima; AN vale 0 y no se elimina.
6. `06_CTS`: calculadora CTS, Excel, requisitos y documentación.
7. `07_Instructores`: pago, ONP/AFP, quinta categoría y EsSalud del empleador.
8. `08_Trabajo_Grupal`: cuentas por cobrar y pagar.
9. `09_Conclusiones`: conclusiones.

## CTS actualizada

Abre `06_CTS/Proyecto/CTSPeru.xcodeproj`. Talana se usa únicamente como referencia de estructura: resultado, información contractual, remuneración y variables. No se copian identidad visual ni código del sitio.

La aplicación incluye año y depósito Mayo/Noviembre; fecha de ingreso y corte por cese opcional; tiempo manual alternativo; ausencias; sueldo; asignación familiar; fijos; principal variable; seis meses de un complemento variable; conceptos semestrales/anuales y reglas adicionales de los regímenes explícitamente admitidos.

La gratificación tiene tres opciones:
- **Estimada:** se actualiza al cambiar el sueldo, con asignación familiar y fijos históricos separados. Supone sueldo constante. Los meses calendario completos de gratificación se ingresan por separado.
- **Percibida:** utiliza el importe efectivamente pagado, sin bonificación extraordinaria; no cambia retroactivamente al editar el sueldo.
- **Histórica:** calcula desde una RC histórica validada y exige confirmar coincidencia con lo percibido.

El importe de gratificación se muestra por separado y no desaparece por un error en los días de CTS. Los días equivalentes usan meses de 30 días. Inicio día 31 y febrero parcial requieren revisión manual. No hay cobertura universal: CAS, 276, construcción y otros muestran revisión; tampoco se automatizan arrastres ni intereses.

## Excel

`06_CTS/CTS_Automatica.xlsx` es la versión actual de una hoja, organizada con referencia a Talana: resultado automático, período, sueldo, asignación familiar, fijos, gratificación estimada/percibida y seis entradas variables complementarias. Corresponde al régimen general. `CTS_Dinamica.xlsx` conserva la versión ampliada anterior y su documentación específica; no es idéntica a la hoja actual.

En el Excel actual: sueldo B16, asignación familiar B17, fijos B18, modo gratificación B19, pago real B20, meses de gratificación B21, asignación histórica B22 y fijos históricos B23. Variables D18:I18. El modo Fechas calcula el tiempo desde año, depósito e ingreso; Manual permite meses y días previamente validados. La estimación simplificada de gratificación no incorpora ausencias ni promedios variables de su propio semestre: si corresponden, usar Percibida. La app admite un cálculo histórico adicional.

## Verificación

- 34 escenarios ejecutados sobre las fórmulas del Excel actual, incluyendo cambios de sueldo, asignación familiar, pagos fijos, variables, períodos e ingresos inválidos. Todos coinciden: `Pruebas_Swift/Casos_Excel_Actualizado.json`.
- La versión ampliada anterior tiene 73 escenarios y 86 comprobaciones de aritmética y archivos documentadas en `VERIFICACION.html`. Hay solapamiento; no sumarlos como escenarios únicos.
- Proyectos revisados estructuralmente; no se ha compilado ni ejecutado SwiftUI en este equipo Windows. Las vistas PNG son referencias, no capturas del simulador.
- Las pruebas nativas están preparadas en `Pruebas_Swift`. En Mac: `swiftc Modelos.swift main.swift -o pruebas_s08` y luego `./pruebas_s08`.
- El recálculo del Excel se probó con el motor de hojas disponible; no con Excel de escritorio.

## Fuentes y alcance

Investigación normativa: corte 27/10/2026. Actualización de archivos: 28/10/2026. Revisa `06_CTS/Normativa_y_Excepciones.html`, `RF_RNF.html` y `Documentacion_CTS.html` para límites y fuentes. Las referencias a celdas de esos documentos corresponden a CTS_Dinamica; las de este README a CTS_Automatica.

- Referencia de organización: https://web.talana.com/es-pe/calculo-de-cts
- TUO/reglamento CTS: https://diariooficial.elperuano.pe/Normas/obtenerDocumento?idNorma=37
- Asignación familiar: https://cdn.www.gob.pe/uploads/document/file/2899623/guia_asignacion_familiar.pdf

`INDICE.html` permite recorrer los documentos descargados. Los datos de prueba son ficticios. No se incluyen datos privados, credenciales ni archivos de usuario de Xcode.
