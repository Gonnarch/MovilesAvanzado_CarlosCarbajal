// Desarrollado con asistencia de IA para Carlos Daniel Carbajal Durand
import UIKit

class CarritoViewController: UIViewController {
    var carrito: CarritoModel!
    @IBOutlet weak var itemsTextView: UITextView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var finalizarButton: UIButton!
    @IBAction func finalizarTapped(_ sender: UIButton) {}
}
