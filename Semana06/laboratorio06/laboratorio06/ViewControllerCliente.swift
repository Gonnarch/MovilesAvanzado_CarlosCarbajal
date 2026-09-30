import UIKit

class ViewControllerCliente: UIViewController {
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDni: UITextField!

    @IBAction func btnContinuar(_ sender: Any) {
        view.endEditing(true)
        let apellido = (tfApellido.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombre = (tfNombre.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (tfDni.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !apellido.isEmpty, !nombre.isEmpty,
              dni.count == 8, dni.allSatisfy({ $0 >= "0" && $0 <= "9" }) else {
            let alerta = UIAlertController(title: "Revisa los datos",
                message: "Ingresa apellido, nombre y un DNI de 8 dígitos.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alerta, animated: true)
            return
        }

        let oCliente = ClienteModel(pCodigo: 0, pApellido: apellido, pNombre: nombre, pDni: dni)
        // Se usa el Storyboard de la pantalla actual: Main o Modal, según el esquema.
        guard let oPantalla2 = storyboard?.instantiateViewController(
            withIdentifier: "ViewControllerConfirmacion") as? ViewControllerConfirmacion else { return }
        oPantalla2.pCliente = oCliente
        present(oPantalla2, animated: true, completion: nil)
    }
}
