// Desarrollado con asistencia de IA para Carlos Daniel Carbajal Durand
import UIKit

class BoletaViewController: UIViewController {
    var carrito: CarritoModel!
    var cliente: ClienteModel!
    var boleta: BoletaModel!
    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var importesLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoTituloLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        guard let boleta = boleta else { return }
        clienteLabel.text = "\(boleta.cliente.Nombre) \(boleta.cliente.Apellido) (\(boleta.categoria)) · DNI \(boleta.cliente.Dni)"
        itemsLabel.text = boleta.nombresLineas
        importesLabel.text = boleta.importesLineas
        subtotalLabel.text = Moneda.formato(boleta.subtotal)
        descuentoTituloLabel.text = "Descuento (\(Int(boleta.porcentaje * 100))%)"
        descuentoLabel.text = "-\(Moneda.formato(boleta.descuento))"
        igvLabel.text = Moneda.formato(boleta.igv)
        totalLabel.text = Moneda.formato(boleta.total)
    }

    @IBAction func cerrarTapped(_ sender: UIButton) {
        let navegacion = presentingViewController as? UINavigationController
            ?? presentingViewController?.navigationController
        dismiss(animated: true) {
            navegacion?.popToRootViewController(animated: true)
        }
    }
}
