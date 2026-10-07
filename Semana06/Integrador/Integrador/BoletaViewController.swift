// Desarrollado con asistencia de IA para Carlos Daniel Carbajal Durand
import UIKit

class BoletaViewController: UIViewController {
    var carrito: CarritoModel!
    var cliente: ClienteModel!
    var boleta: BoletaModel!
    @IBOutlet weak var boletaTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Obliga a usar Cerrar para regresar al catálogo después de confirmar.
        isModalInPresentation = true
        boletaTextView.text = boleta?.texto() ?? "No hay una boleta disponible."
    }

    @IBAction func cerrarTapped(_ sender: UIButton) {
        // Reto opcional 1: cierra la modal y vuelve directamente al catálogo.
        let navegacion = presentingViewController as? UINavigationController
            ?? presentingViewController?.navigationController
        dismiss(animated: true) {
            navegacion?.popToRootViewController(animated: true)
        }
    }
}
