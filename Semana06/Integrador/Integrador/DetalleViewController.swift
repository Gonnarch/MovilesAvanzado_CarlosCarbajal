// Desarrollado con asistencia de IA para Carlos Daniel Carbajal Durand
import UIKit

class DetalleViewController: UIViewController {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!
    @IBAction func cantidadChanged(_ sender: UIStepper) {}
    @IBAction func agregarTapped(_ sender: UIButton) {}
}
