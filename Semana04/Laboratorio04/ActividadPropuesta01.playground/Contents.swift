import Foundation

// ACTIVIDAD PROPUESTA 01 - CURSOS LIBRES DE TECSUP

struct CursoLibre {
    let nombre: String
    let precio: Double
}

class Alumno {
    let nombre: String
    let esAlumnoTecsup: Bool
    var cursos: [CursoLibre] = []

    init(nombre: String, esAlumnoTecsup: Bool) {
        self.nombre = nombre
        self.esAlumnoTecsup = esAlumnoTecsup
    }

    func inscribir(curso: CursoLibre) {
        cursos.append(curso)
    }

    func calcularPago() {
        var subtotal = 0.0
        for curso in cursos {
            subtotal = subtotal + curso.precio
        }

        let totalConIGV = subtotal * 1.18
        var descuentoPorCursos = 0.0
        var descuentoTecsup = 0.0

        if cursos.count >= 3 {
            descuentoPorCursos = totalConIGV * 0.10
            if esAlumnoTecsup {
                descuentoTecsup = 400.0
            }
        }

        var totalFinal = totalConIGV - descuentoPorCursos - descuentoTecsup
        if totalFinal < 0.0 {
            totalFinal = 0.0
        }

        print("Alumno: \(nombre)")
        print("Cantidad de cursos: \(cursos.count)")
        print("Total con IGV: S/ \(totalConIGV)")
        print("Descuento por 3 o mas cursos: S/ \(descuentoPorCursos)")
        print("Descuento por ser alumno Tecsup: S/ \(descuentoTecsup)")
        print("Total a pagar: S/ \(totalFinal)")
    }
}

let alumno = Alumno(nombre: "Carlos Carbajal", esAlumnoTecsup: true)
alumno.inscribir(curso: CursoLibre(nombre: "Swift basico", precio: 500.0))
alumno.inscribir(curso: CursoLibre(nombre: "Base de datos", precio: 450.0))
alumno.inscribir(curso: CursoLibre(nombre: "Desarrollo web", precio: 550.0))
alumno.calcularPago()
