import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var yearsTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(closeKeyboard))]
        capitalTextField.inputAccessoryView = toolbar
        rateTextField.inputAccessoryView = toolbar
        yearsTextField.inputAccessoryView = toolbar

    }

    @objc private func closeKeyboard() { view.endEditing(true) }

    @IBAction func CalcularResultado(_ sender: Any) {
        view.endEditing(true)
        guard let capital = DecimalInput.parse(capitalTextField.text),
              let rate = DecimalInput.parse(rateTextField.text),
              let years = DecimalInput.parse(yearsTextField.text),
              let result = LoanCalculator.calculate(principal: capital, annualRate: rate, years: years) else {
            resultLabel.text = "Ingresa un capital positivo, una tasa no negativa y un plazo de 1 a 1200 meses completos expresado en años. Usa coma o punto decimal, sin separadores de miles."
            return
        }
        resultLabel.text = "Cuota mensual: \(String(format: "%.2f", result.monthlyPayment))\nMonto total a pagar: \(String(format: "%.2f", result.totalPayment))\nIntereses: \(String(format: "%.2f", result.interest))\nNúmero de cuotas: \(result.months)"
    }
}
