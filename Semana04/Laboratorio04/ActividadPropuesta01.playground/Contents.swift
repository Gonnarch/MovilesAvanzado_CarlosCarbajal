import Foundation

// ACTIVIDAD PROPUESTA 01 - CURSOS LIBRES DE TECSUP

struct CursoLibre {
    let nombre: String
    let cantidad: Int
    let precioUnitario: Double

    func subtotal() -> Double {
        return Double(cantidad) * precioUnitario
    }
}

class Alumno {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
    var cursos: [CursoLibre] = []

    init(nombre: String, dni: String, esAlumnoTecsup: Bool) {
        self.nombre = nombre
        self.dni = dni
        self.esAlumnoTecsup = esAlumnoTecsup
    }

    func inscribir(curso: CursoLibre) {
        cursos.append(curso)
    }

    func calcularPago() {
        var subtotal = 0.0
        var cantidadTotalCursos = 0

        print("🎓 FACTURA DE CURSOS")
        print("Estudiante: \(nombre)")
        print("DNI: \(dni)")
        print("Alumno de Tecsup: \(esAlumnoTecsup ? "Sí ✅" : "No ❌")")
        print("")

        for curso in cursos {
            let montoCurso = curso.subtotal()
            subtotal = subtotal + montoCurso
            cantidadTotalCursos = cantidadTotalCursos + curso.cantidad
            print("\(curso.nombre) x\(curso.cantidad) -> S/ \(String(format: "%.2f", montoCurso))")
        }

        let igv = subtotal * 0.18
        let totalConIGV = subtotal + igv
        var descuentoPorCantidad = 0.0
        var descuentoTecsup = 0.0

        if cantidadTotalCursos >= 3 {
            descuentoPorCantidad = totalConIGV * 0.10

            if esAlumnoTecsup {
                descuentoTecsup = 400.0
            }
        }

        var totalFinal = totalConIGV - descuentoPorCantidad - descuentoTecsup

        if totalFinal < 0.0 {
            totalFinal = 0.0
        }

        print("")
        print("Subtotal: S/ \(String(format: "%.2f", subtotal))")
        print("IGV (18%): S/ \(String(format: "%.2f", igv))")
        print("Total con IGV: S/ \(String(format: "%.2f", totalConIGV))")
        print("Descuento 10% por cantidad: -S/ \(String(format: "%.2f", descuentoPorCantidad)) \(cantidadTotalCursos >= 3 ? "✅" : "❌")")
        print("Descuento especial Tecsup: -S/ \(String(format: "%.2f", descuentoTecsup)) \(descuentoTecsup > 0 ? "✅" : "❌")")
        print("")
        print("💰 TOTAL FINAL A PAGAR: S/ \(String(format: "%.2f", totalFinal))")
    }
}

let alumno = Alumno(nombre: "Juan León", dni: "78965432", esAlumnoTecsup: true)

alumno.inscribir(curso: CursoLibre(nombre: "Swift Avanzado", cantidad: 1, precioUnitario: 450.0))
alumno.inscribir(curso: CursoLibre(nombre: "IA con Python", cantidad: 2, precioUnitario: 650.0))
alumno.inscribir(curso: CursoLibre(nombre: "Diseño UX/UI", cantidad: 1, precioUnitario: 500.0))

alumno.calcularPago()
