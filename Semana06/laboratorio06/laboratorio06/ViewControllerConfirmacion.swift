import UIKit

class ViewControllerConfirmacion: UIViewController {
    var pCliente: ClienteModel = ClienteModel()
    @IBOutlet weak var tfApellido: UILabel!
    @IBOutlet weak var tfNombre: UILabel!
    @IBOutlet weak var tfDni: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfApellido.text = pCliente.Apellido
        tfNombre.text = pCliente.Nombre
        tfDni.text = pCliente.Dni
    }

    @IBAction func btnCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
