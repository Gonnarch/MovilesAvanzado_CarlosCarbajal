import Foundation

// LABORATORIO 04 - PROGRAMACION ORIENTADA A OBJETOS EN SWIFT
// Alumno: Carlos Carbajal

// ===== CASO 1.5: HERENCIA Y POLIMORFISMO =====

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    func descuento() -> Double {
        return 0.05
    }

    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    // Este flujo se escribe una sola vez y no se sobreescribe en las subclases.
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }

    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500.0 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let envio = monto * 0.08
        if envio < 50.0 {
            return 50.0
        } else {
            return envio
        }
    }
}

class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }

    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}

let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

// Para obtener primero los seis precios exactos de la salida esperada se usan estas tres sucursales.
let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tienda Online", ciudad: "Internet")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// Prueba final: se necesitaron 6 lineas nuevas: 5 para la clase y 1 para agregar su instancia.
// Si se incluye en el array, los mismos for-in tambien la cotizan sin modificarlos.

// ===== FIX 7 Y FIX 8 =====

class SucursalMall: Sucursal {
    // FIX 7: faltaba override porque este metodo ya existe en la clase padre.
    override func descuento() -> Double {
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        // FIX 8: faltaba inicializar la parte heredada de Sucursal.
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// PREDICT 6: imprime 0.1. Aunque la variable es Sucursal, el objeto real es SucursalLima.
// PREDICT 7: imprime 0.0, porque despues del descuento el monto es 1800 y el envio es gratis.

// ===== CASO 2 - PARTE A: BIBLIOTECA SIN IA =====

enum EstadoLibro {
    case disponible, prestado
}

struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

class Biblioteca {
    var libros: [Libro] = []

    func agregar(libro: Libro) {
        libros.append(libro)
    }

    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya esta prestado")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }

    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya esta disponible")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }

    func inventario() {
        print("===== INVENTARIO =====")
        for libro in libros {
            var textoEstado = ""
            switch libro.estado {
            case .disponible:
                textoEstado = "disponible"
            case .prestado:
                textoEstado = "prestado"
            }
            print("\(libro.titulo) (\(libro.autor)) - \(textoEstado)")
        }
    }
}

let biblioteca = Biblioteca()
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.devolver(titulo: "La ciudad y los perros")
biblioteca.prestar(titulo: "El Quijote")
biblioteca.prestar(titulo: "El Principito")
biblioteca.inventario()
