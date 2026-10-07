// Desarrollado por: Carlos Daniel Carbajal Durand
import UIKit

class DatosClienteViewController: UIViewController, UITextFieldDelegate {
    var carrito: CarritoModel!
    private var cliente: ClienteModel?
    private var boleta: BoletaModel?
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var confirmarButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        apellidoTextField.delegate = self
        nombreTextField.delegate = self
        dniTextField.delegate = self
    }

    @IBAction func confirmarTapped(_ sender: UIButton) {
        // Evita confirmar dos veces la misma compra.
        guard boleta == nil else { return }
        let apellido = (apellidoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombre = (nombreTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (dniTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if let error = ValidacionCliente.error(apellido: apellido, nombre: nombre, dni: dni) {
            mostrarError(error)
            return
        }
        let nuevoCliente = ClienteModel(pCodigo: 1, pApellido: apellido, pNombre: nombre, pDni: dni)
        guard let carrito = carrito,
              let comprobante = carrito.confirmarCompra(cliente: nuevoCliente) else {
            mostrarError("El carrito está vacío o no hay stock suficiente. Vuelve al catálogo para revisar la compra.")
            return
        }
        cliente = nuevoCliente
        boleta = comprobante
        confirmarButton.isEnabled = false
        view.endEditing(true)
        performSegue(withIdentifier: "verBoleta", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verBoleta",
           let destino = segue.destination as? BoletaViewController {
            destino.carrito = carrito
            destino.cliente = cliente
            destino.boleta = boleta
            if let sheet = destino.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    let altura = UISheetPresentationController.Detent.Identifier("boleta")
                    sheet.detents = [.custom(identifier: altura) { contexto in
                        min(550, contexto.maximumDetentValue)
                    }, .large()]
                    sheet.selectedDetentIdentifier = altura
                } else {
                    sheet.detents = [.large()]
                }
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === apellidoTextField { nombreTextField.becomeFirstResponder() }
        else if textField === nombreTextField { dniTextField.becomeFirstResponder() }
        else { textField.resignFirstResponder() }
        return true
    }

    private func mostrarError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Revisa tus datos", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
