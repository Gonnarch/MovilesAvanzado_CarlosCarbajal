import Foundation
var total = 0
func igual(_ actual: Double, _ esperado: Double, _ nombre: String) {
    precondition(abs(actual - esperado) < 0.005, "Falla: \(nombre): \(actual), esperado \(esperado)")
    total += 1
}
func exigeError(_ nombre: String, _ f: () throws -> Void) {
    do { try f(); fatalError("No rechazó: \(nombre)") } catch { total += 1 }
}
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
print("Pruebas de modelos Swift completadas: \(total)")
