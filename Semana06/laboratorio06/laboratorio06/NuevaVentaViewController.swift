import UIKit

class NuevaVentaViewController: UIViewController {
    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecio: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfTasa: UITextField!
    private var venta: VentaModel?

    // El botón Calcular tiene el segue Show showResultado en el Storyboard.
    // UIKit consulta este método antes de permitir la transición.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "showResultado" { return true }
        view.endEditing(true)
        let nombre = (tfElectrodomestico.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nombre.isEmpty,
              let precio = numero(tfPrecio.text), precio.isFinite, precio > 0,
              let cantidad = Int((tfCantidad.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)), cantidad > 0,
              let meses = Int((tfMeses.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)), meses > 0,
              let tasa = numero(tfTasa.text), tasa.isFinite, tasa >= 0 else {
            mostrarError("Completa el nombre. Precio, cantidad y meses deben ser mayores que cero. La tasa puede ser cero. Cantidad y meses deben ser enteros.")
            return false
        }
        let resultado = VentaModel()
        resultado.subtotal = precio * Double(cantidad)
        resultado.igv = resultado.subtotal * 0.18
        resultado.base = resultado.subtotal + resultado.igv
        // Supuesto documentado: interés simple mensual sobre el monto base.
        resultado.intereses = resultado.base * (tasa / 100) * Double(meses)
        resultado.total = resultado.base + resultado.intereses
        resultado.cuota = resultado.total / Double(meses)
        guard [resultado.subtotal, resultado.igv, resultado.base, resultado.intereses,
               resultado.total, resultado.cuota].allSatisfy({ $0.isFinite }) else {
            mostrarError("Los valores son demasiado grandes. Ingresa valores menores.")
            return false
        }
        venta = resultado
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado",
           let destino = segue.destination as? ResultadoViewController,
           let resultado = venta {
            destino.venta = resultado
        }
    }

    private func numero(_ texto: String?) -> Double? {
        return Double((texto ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: "."))
    }

    private func mostrarError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Revisa la venta", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
