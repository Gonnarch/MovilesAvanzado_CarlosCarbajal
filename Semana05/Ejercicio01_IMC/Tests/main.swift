import Foundation

func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    guard condition() else { fatalError(message) }
}
check(DecimalInput.parse(" 1,70 ") == 1.7, "Coma decimal")
check(DecimalInput.parse("1.70") == 1.7, "Punto decimal")
for text in ["", "abc", "nan", "inf", "1,2.3"] {
    check(DecimalInput.parse(text) == nil, "Rechazar entrada: \(text)")
}
let normal = IMCCalculator.calculate(weight: 70, height: 1.70)!
check(abs(normal.value - 24.221453287197235) < 0.000001, "Ejemplo de la guia")
check(normal.status == "Peso normal", "Clasificacion")
for (value, expected) in [(18.49, "Bajo peso"), (18.5, "Peso normal"), (24.89, "Peso normal"), (24.9, "Sobrepeso"), (29.89, "Sobrepeso"), (29.9, "Obesidad")] {
    check(IMCCalculator.calculate(weight: value, height: 1)!.status == expected, "Limite: \(value)")
}
for value in [0.0, -1.0, Double.nan, Double.infinity] {
    check(IMCCalculator.calculate(weight: value, height: 1.7) == nil, "Peso invalido")
    check(IMCCalculator.calculate(weight: 70, height: value) == nil, "Altura invalida")
}
print("Todas las pruebas pasaron.")
