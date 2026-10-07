// Desarrollado con asistencia de IA para Carlos Daniel Carbajal Durand
import UIKit

class CatalogoViewController: UIViewController {
    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4),
        Producto(nombre: "Microondas", precio: 450, stock: 6)
    ]

    // Prueba final (regla 10): un bloque de cambio en Storyboard
    // (duplicar botón, título Microondas, tag 4 y misma acción productoTapped:)
    // y un cambio en código (agregar una entrada al array productos).
    // No se agregaron segues ni se modificaron los demás controladores/modelos.

    // Única creación del carrito en toda la aplicación.
    let carrito = CarritoModel()
    @IBOutlet weak var verCarritoButton: UIButton!

    // B2: también se ejecuta al regresar desde Detalle o después de una compra.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verCarritoButton.setTitle("Ver carrito (\(carrito.cantidadTotal()))", for: .normal)
    }

    @IBAction func productoTapped(_ sender: UIButton) {
        guard productos.indices.contains(sender.tag) else { return }
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    @IBAction func verCarritoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verCarrito", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle",
           let boton = sender as? UIButton,
           productos.indices.contains(boton.tag),
           let destino = segue.destination as? DetalleViewController {
            destino.producto = productos[boton.tag]
            destino.carrito = carrito
        }
        // B1: se comparte el mismo objeto, sin inicializar otro carrito.
        if segue.identifier == "verCarrito",
           let destino = segue.destination as? CarritoViewController {
            destino.carrito = carrito
        }
    }
}
