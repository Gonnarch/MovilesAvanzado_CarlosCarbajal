// Desarrollado por: Carlos Daniel Carbajal Durand
import Foundation

class Producto {
    let nombre: String
    private let precioBase: Double
    var precio: Double { precioBase }
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precioBase = precio
        self.stock = stock
    }
}

// Reto 3: el carrito usa el precio sobrescrito sin distinguir el tipo de producto.
class ProductoImportado: Producto {
    override var precio: Double { super.precio * 1.08 }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int

    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }

    func subtotal() -> Double {
        producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    private(set) var items: [ItemCarrito] = []

    // A1: compara identidad, acumula una sola línea y valida el stock reservado.
    @discardableResult
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        guard cantidad > 0 else { return false }
        let existente = items.first { $0.producto === producto }
        let reservada = existente?.cantidad ?? 0
        guard reservada <= producto.stock,
              cantidad <= producto.stock - reservada else { return false }
        if let item = existente {
            item.cantidad += cantidad
        } else {
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }

    // A2
    func subtotal() -> Double {
        items.reduce(0) { $0 + $1.subtotal() }
    }

    // A3: evaluar de mayor a menor para escoger un solo tramo.
    func porcentajeDescuento() -> Double {
        let importe = subtotal()
        if importe >= 5000 { return 0.15 }
        if importe >= 2000 { return 0.10 }
        if importe >= 500 { return 0.05 }
        return 0
    }

    // A4
    func cantidadTotal() -> Int {
        items.reduce(0) { $0 + $1.cantidad }
    }

    // A5
    func vaciar() {
        items.removeAll()
    }

    // Reto 2: elimina la última línea completa, sin descontar stock físico.
    @discardableResult
    func quitarUltimoProducto() -> ItemCarrito? {
        items.popLast()
    }

    func cantidadReservada(de producto: Producto) -> Int {
        items.first { $0.producto === producto }?.cantidad ?? 0
    }

    func descuento() -> Double { subtotal() * porcentajeDescuento() }
    func baseImponible() -> Double { subtotal() - descuento() }
    func igv() -> Double { baseImponible() * 0.18 }
    func total() -> Double { baseImponible() + igv() }

    func categoriaCliente() -> String {
        switch Int(subtotal()) {
        case ..<500: return "Regular"
        case 500..<2000: return "Frecuente"
        case 2000..<5000: return "VIP"
        default: return "Premium"
        }
    }

    func detalleLineas() -> String {
        items.map { "\($0.producto.nombre) x\($0.cantidad)    \(Moneda.formato($0.subtotal()))" }
            .joined(separator: "\n\n")
    }

    func nombresLineas() -> String {
        items.map { "\($0.producto.nombre) x\($0.cantidad)" }.joined(separator: "\n")
    }

    func importesLineas() -> String {
        items.map { Moneda.formato($0.subtotal()) }.joined(separator: "\n")
    }

    // Guarda valores inmutables ANTES de descontar stock y vaciar el carrito.
    // Se valida el conjunto completo antes de modificar cualquier producto.
    func confirmarCompra(cliente: ClienteModel) -> BoletaModel? {
        guard !items.isEmpty,
              items.allSatisfy({ $0.cantidad > 0 && $0.cantidad <= $0.producto.stock }) else {
            return nil
        }
        let boleta = BoletaModel(cliente: cliente, categoria: categoriaCliente(),
                                 lineas: detalleLineas(), nombresLineas: nombresLineas(),
                                 importesLineas: importesLineas(), subtotal: subtotal(),
                                 porcentaje: porcentajeDescuento(), descuento: descuento(),
                                 igv: igv(), total: total())
        for item in items {
            item.producto.stock -= item.cantidad
        }
        vaciar()
        return boleta
    }
}

// La boleta conserva las líneas y montos aunque el carrito compartido ya esté vacío.
class BoletaModel {
    let cliente: ClienteModel
    let categoria: String
    let lineas: String
    let nombresLineas: String
    let importesLineas: String
    let subtotal: Double
    let porcentaje: Double
    let descuento: Double
    let igv: Double
    let total: Double

    init(cliente: ClienteModel, categoria: String, lineas: String,
         nombresLineas: String, importesLineas: String, subtotal: Double,
         porcentaje: Double, descuento: Double, igv: Double, total: Double) {
        self.cliente = cliente
        self.categoria = categoria
        self.lineas = lineas
        self.nombresLineas = nombresLineas
        self.importesLineas = importesLineas
        self.subtotal = subtotal
        self.porcentaje = porcentaje
        self.descuento = descuento
        self.igv = igv
        self.total = total
    }

    func texto() -> String {
        """
        Cliente: \(cliente.Nombre) \(cliente.Apellido) (\(categoria))
        DNI: \(cliente.Dni)
        ----------------------------------------
        \(lineas)
        ----------------------------------------
        Subtotal: \(Moneda.formato(subtotal))
        Descuento (\(Int(porcentaje * 100))%): -\(Moneda.formato(descuento))
        IGV (18%): \(Moneda.formato(igv))
        TOTAL: \(Moneda.formato(total))
        ========================================
        """
    }
}

enum Moneda {
    static func formato(_ importe: Double) -> String {
        String(format: "S/ %.2f", locale: Locale(identifier: "en_US_POSIX"), importe)
    }
}

enum ValidacionCliente {
    static func error(apellido: String, nombre: String, dni: String) -> String? {
        guard !apellido.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !dni.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Completa apellidos, nombres y DNI."
        }
        guard dni.count == 8, dni.utf8.allSatisfy({ (48...57).contains($0) }) else {
            return "El DNI debe contener exactamente 8 dígitos del 0 al 9."
        }
        return nil
    }
}
