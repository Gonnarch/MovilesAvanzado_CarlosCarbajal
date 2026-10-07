// Desarrollado por: Carlos Daniel Carbajal Durand
import UIKit

class DetalleViewController: UIViewController {
    var producto: Producto!
    var carrito: CarritoModel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración de comportamiento del control colocado manualmente en Storyboard.
        // A 1 unidad, el botón menos está deshabilitado por el límite mínimo.
        cantidadStepper.minimumValue = 1
        cantidadStepper.maximumValue = 100
        cantidadStepper.stepValue = 1
        cantidadStepper.value = 1
        cantidadStepper.isEnabled = true
        cantidadStepper.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard producto != nil, carrito != nil else { return }
        nombreLabel.text = producto.nombre
        precioLabel.text = Moneda.formato(producto.precio)
        actualizarCantidadYStock()
    }

    @IBAction func cantidadChanged(_ sender: UIStepper) {
        cantidadLabel.text = "\(Int(sender.value))"
    }

    @IBAction func agregarTapped(_ sender: UIButton) {
        guard let producto = producto, let carrito = carrito else { return }
        guard carrito.agregar(producto: producto, cantidad: Int(cantidadStepper.value)) else {
            let disponible = max(0, producto.stock - carrito.cantidadReservada(de: producto))
            let alerta = UIAlertController(title: "Stock insuficiente",
                                          message: "Puedes agregar hasta \(disponible) unidad(es) de \(producto.nombre).",
                                          preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alerta, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    private func actualizarCantidadYStock() {
        stockLabel.text = "\(producto.stock)"
        cantidadLabel.text = "\(Int(cantidadStepper.value))"
    }
}
