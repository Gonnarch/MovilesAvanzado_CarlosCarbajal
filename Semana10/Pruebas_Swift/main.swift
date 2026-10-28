import Foundation
var total = 0
func igual(_ actual: Double, _ esperado: Double, _ nombre: String) {
    precondition(abs(actual - esperado) < 0.005, "Falla: \(nombre): \(actual), esperado \(esperado)")
    total += 1
}
func exigeError(_ nombre: String, _ f: () throws -> Void) {
    do { try f(); fatalError("No rechazó: \(nombre)") } catch { total += 1 }
}
var d = DatosCTS()
igual(try CTSModelo.calcular(d).importe!, 1750, "CTS base")
d.meses = 3; d.dias = 15
igual(try CTSModelo.calcular(d).importe!, 1020.83, "CTS trunca")
d = DatosCTS(); d.ausencias = 5
igual(try CTSModelo.calcular(d).importe!, 1701.39, "CTS ausencias")
d = DatosCTS(); d.variables = [300,0,600,0,900,0]
igual(try CTSModelo.calcular(d).importe!, 1900, "CTS complemento regular")
d.variables = [300,0,600,0,0,0]
igual(try CTSModelo.calcular(d).importe!, 1750, "CTS complemento no regular")
d = DatosCTS(); d.principalVariable = true; d.principalTotal = 24000; d.gratificacion = 4000
igual(try CTSModelo.calcular(d).importe!, 2333.33, "CTS principal variable")
d = DatosCTS(); d.regimen = .pequena; d.gratificacion = 1500
igual(try CTSModelo.calcular(d).importe!, 812.5, "CTS pequeña")
d.diasTopeRestantes = 2
igual(try CTSModelo.calcular(d).importe!, 216.67, "CTS tope")
d = DatosCTS(); d.regimen = .micro
igual(try CTSModelo.calcular(d).importe!, 0, "Micro comprendida")
d.regimen = .cas
let cas = try CTSModelo.calcular(d)
precondition(cas.importe == nil); total += 1
d = DatosCTS(); d.regimen = .agrario
igual(try CTSModelo.calcular(d).importe!, 119.56, "Agrario")
d = DatosCTS(); d.meses = 2.5
exigeError("meses fraccionarios") { _ = try CTSModelo.calcular(d) }
exigeError("vacío") { _ = try Entrada.numero("", "sueldo") }
exigeError("negativo") { _ = try Entrada.numero("-1", "sueldo") }
igual(try Entrada.numero("170,6", "altura"), 170.6, "coma decimal")
igual(try PesoModelo.calcular(altura: "170", edad: "", mujer: false), 66.2, "Peso hombre")
igual(try PesoModelo.calcular(altura: "170", edad: "", mujer: true), 61.7, "Peso mujer")
igual(Double(try NotasModelo.calcular(["12","15","18","10"]).redondeado), 15, "Notas")
igual(Double(try NotasModelo.calcular(["12","15","18","AN"]).redondeado), 11, "AN protegido")
igual(Double(try NotasModelo.calcular(["AN","AN","AN","AN"]).redondeado), 0, "Cuatro AN")
igual(Double(try NotasModelo.calcular(["0","13","13.5","14"]).redondeado), 14, "Redondeo")
exigeError("nota fuera de rango") { _ = try NotasModelo.calcular(["21","10","10","10"]) }
igual(PagoModelo.impuestoAnual(65228, uit: 5500), 2138.24, "Impuesto anual")
igual(PagoModelo.retencion(ingreso: 65228, uit: 5500, mes: 1, retenido: 0, extraordinario: 0), 178.19, "Retención enero")
igual(PagoModelo.retencion(ingreso: 65228, uit: 5500, mes: 10, retenido: 1425.52, extraordinario: 0), 178.18, "Retención octubre")
let tiempo = try CTSAutomatizacion.tiempo(ingreso: "2026-07-16", inicio: "2026-05-01", corte: "2026-10-31")
igual(tiempo.meses, 3, "Fechas meses")
igual(tiempo.dias, 15, "Fechas días")
let febrero = try CTSAutomatizacion.tiempo(ingreso: "2025-01-01", inicio: "2025-11-01", corte: "2026-02-28")
igual(febrero.meses, 4, "Febrero completo")
let bisiesto = try CTSAutomatizacion.tiempo(ingreso: "2023-01-01", inicio: "2023-11-01", corte: "2024-02-29")
igual(bisiesto.meses, 4, "Febrero bisiesto")
exigeError("Fecha imposible") { _ = try CTSAutomatizacion.tiempo(ingreso: "2026-02-30", inicio: "2026-05-01", corte: "2026-10-31") }
exigeError("Ingreso posterior") { _ = try CTSAutomatizacion.tiempo(ingreso: "2026-11-01", inicio: "2026-05-01", corte: "2026-10-31") }
exigeError("Día 31 requiere revisión") { _ = try CTSAutomatizacion.tiempo(ingreso: "2026-07-31", inicio: "2026-05-01", corte: "2026-10-31") }
igual(try CTSAutomatizacion.gratificacion(rc: 3000, meses: 3, ausencias: 0, regimen: .general, confirmado: true), 1500, "Grati parcial")
igual(try CTSAutomatizacion.gratificacion(rc: 3000, meses: 6, ausencias: 6, regimen: .general, confirmado: true), 2900, "Grati ausencias")
igual(try CTSAutomatizacion.gratificacion(rc: 3000, meses: 6, ausencias: 0, regimen: .pequena, confirmado: true), 1500, "Grati pequeña")
exigeError("Grati sin boleta confirmada") { _ = try CTSAutomatizacion.gratificacion(rc: 3000, meses: 6, ausencias: 0, regimen: .general, confirmado: false) }
let mayo = try CTSAutomatizacion.periodo(anio: 2026, noviembre: false)
precondition(mayo.inicio == "2025-11-01" && mayo.fin == "2026-04-30"); total += 1
let noviembre = try CTSAutomatizacion.periodo(anio: 2026, noviembre: true)
precondition(noviembre.inicio == "2026-05-01" && noviembre.fin == "2026-10-31"); total += 1
exigeError("Año de depósito inválido") { _ = try CTSAutomatizacion.periodo(anio: 0, noviembre: true) }
igual(try CTSAutomatizacion.estimar(sueldo: 3000, familiar: 113, fijos: 0, meses: 6, ausencias: 0, regimen: .general), 3113, "Grati y familiar histórica")
igual(try CTSAutomatizacion.estimar(sueldo: 4000, familiar: 113, fijos: 0, meses: 6, ausencias: 0, regimen: .general), 4113, "Grati cambia al cambiar sueldo")
igual(try CTSAutomatizacion.estimar(sueldo: 3000, familiar: 0, fijos: 0, meses: 3, ausencias: 0, regimen: .general), 1500, "Grati tres meses completos")
exigeError("Asignación histórica negativa") { _ = try CTSAutomatizacion.estimar(sueldo: 3000, familiar: -1, fijos: 0, meses: 6, ausencias: 0, regimen: .general) }
print("Pruebas de modelos Swift completadas: \(total)")
