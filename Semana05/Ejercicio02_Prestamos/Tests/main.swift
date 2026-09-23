import Foundation

func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    guard condition() else { fatalError(message) }
}
check(DecimalInput.parse(" 1,70 ") == 1.7, "Coma decimal")
check(DecimalInput.parse("1.70") == 1.7, "Punto decimal")
for text in ["", "abc", "nan", "inf", "1,2.3"] {
    check(DecimalInput.parse(text) == nil, "Rechazar entrada: \(text)")
}
let loan = LoanCalculator.calculate(principal: 10000, annualRate: 12, years: 1)!
check(abs(loan.monthlyPayment - 888.487886783416) < 0.000001, "Cuota de referencia")
check(abs(loan.totalPayment - 10661.854641400993) < 0.000001, "Monto total")
check(loan.months == 12, "Numero de cuotas")
let zero = LoanCalculator.calculate(principal: 1200, annualRate: 0, years: 1)!
check(zero.monthlyPayment == 100 && zero.totalPayment == 1200 && zero.interest == 0, "Tasa cero")
check(LoanCalculator.calculate(principal: 600, annualRate: 0, years: 0.5)!.months == 6, "Medio ano")
for value in [0.0, -1.0, Double.nan, Double.infinity] {
    check(LoanCalculator.calculate(principal: value, annualRate: 12, years: 1) == nil, "Capital invalido")
    check(LoanCalculator.calculate(principal: 1000, annualRate: 12, years: value) == nil, "Plazo invalido")
}
check(LoanCalculator.calculate(principal: 1000, annualRate: -1, years: 1) == nil, "Tasa negativa")
check(LoanCalculator.calculate(principal: 1000, annualRate: .nan, years: 1) == nil, "Tasa NaN")
check(LoanCalculator.calculate(principal: 1000, annualRate: 12, years: 0.1) == nil, "Mes fraccionario")
check(LoanCalculator.calculate(principal: 1000, annualRate: 12, years: 101) == nil, "Plazo excesivo")
let tiny = LoanCalculator.calculate(principal: 1200, annualRate: 0.00000001, years: 1)!
check(abs(tiny.monthlyPayment - 100) < 0.0001, "Estabilidad para tasa pequena")
print("Todas las pruebas pasaron.")
