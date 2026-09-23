import Foundation

struct LoanResult {
    let monthlyPayment: Double
    let totalPayment: Double
    let interest: Double
    let months: Int
}

enum LoanCalculator {
    static func calculate(principal: Double, annualRate: Double, years: Double) -> LoanResult? {
        guard principal.isFinite, annualRate.isFinite, years.isFinite,
              principal > 0, annualRate >= 0, years > 0 else { return nil }
        let payments = years * 12
        // El plazo debe representar meses completos. El limite evita desbordamientos.
        guard payments.isFinite, payments >= 1, payments <= 1200,
              abs(payments - payments.rounded()) < 0.0000001 else { return nil }
        let months = Int(payments.rounded())
        let rate = annualRate / 100 / 12
        let monthly: Double
        if rate == 0 {
            monthly = principal / Double(months)
        } else {
            // Equivalente a P*r*(1+r)^n/((1+r)^n-1), estable para tasas pequenas.
            let denominator = -expm1(-Double(months) * log1p(rate))
            guard denominator > 0 else { return nil }
            monthly = principal * (rate / denominator)
        }
        let total = monthly * Double(months)
        guard monthly.isFinite, total.isFinite, monthly > 0 else { return nil }
        return LoanResult(monthlyPayment: monthly, totalPayment: total,
                          interest: max(0, total - principal), months: months)
    }
}

enum DecimalInput {
    // Acepta coma o punto decimal, pero no separadores de miles.
    static func parse(_ text: String?) -> Double? {
        guard let text = text else { return nil }
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value.isFinite else { return nil }
        return value
    }
}
