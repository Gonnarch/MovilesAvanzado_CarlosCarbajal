import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(closeKeyboard))]
        weightTextField.inputAccessoryView = toolbar
        heightTextField.inputAccessoryView = toolbar

    }

    @objc private func closeKeyboard() { view.endEditing(true) }

    @IBAction func CalcularResultado(_ sender: Any) {
        view.endEditing(true)
        guard let weight = DecimalInput.parse(weightTextField.text),
              let height = DecimalInput.parse(heightTextField.text),
              let result = IMCCalculator.calculate(weight: weight, height: height) else {
            resultLabel.text = "Por favor, ingresa peso y altura válidos y mayores que cero."
            return
        }
        resultLabel.text = "IMC: \(String(format: "%.2f", result.value)) - \(result.status)"
    }
}
