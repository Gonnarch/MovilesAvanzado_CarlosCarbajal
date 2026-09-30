import UIKit

// Una clase permite compartir la misma instancia entre ambos controladores.
// Una struct también permitiría pasar datos hacia adelante, pero enviaría un valor.
class VentaModel: NSObject {
    var subtotal: Double = 0
    var igv: Double = 0
    var base: Double = 0
    var intereses: Double = 0
    var total: Double = 0
    var cuota: Double = 0
}
