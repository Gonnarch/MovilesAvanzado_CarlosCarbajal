// Desarrollado por: Carlos Daniel Carbajal Durand
import UIKit

class CarritoViewController: UIViewController {
    var carrito: CarritoModel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var importesLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoTituloLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var finalizarButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let carrito = carrito else { return }
        itemsLabel.text = carrito.items.isEmpty ? "Tu carrito está vacío." : carrito.nombresLineas()
        importesLabel.text = carrito.importesLineas()
        subtotalLabel.text = Moneda.formato(carrito.subtotal())
        descuentoTituloLabel.text = "Descuento (\(Int(carrito.porcentajeDescuento() * 100))%)"
        descuentoLabel.text = "-\(Moneda.formato(carrito.descuento()))"
        igvLabel.text = Moneda.formato(carrito.igv())
        totalLabel.text = Moneda.formato(carrito.total())
        categoriaLabel.text = "Categoría: \(carrito.categoriaCliente())"
    }

    @IBAction func finalizarTapped(_ sender: UIButton) {
        guard let carrito = carrito, !carrito.items.isEmpty else {
            let alerta = UIAlertController(title: "Carrito vacío", message: "Agrega un producto antes de finalizar la compra.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alerta, animated: true)
            return
        }
        performSegue(withIdentifier: "irDatosCliente", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irDatosCliente",
           let destino = segue.destination as? DatosClienteViewController {
            destino.carrito = carrito
        }
    }
}
