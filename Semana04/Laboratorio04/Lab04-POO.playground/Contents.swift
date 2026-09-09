import Foundation // permite utilizar elementos basicos del lenguaje Swift

// ===== CASO 2 - PARTE B: BIBLIOTECA CON IA =====

enum EstadoLibro { // agrupa los dos estados permitidos para un libro
    case disponible // representa un libro que puede prestarse
    case prestado // representa un libro que ya fue prestado
} // termina la declaracion del enum

struct Libro { // representa los datos de cada libro como un tipo por valor
    let titulo: String // guarda el titulo y evita que cambie despues de crearlo
    let autor: String // guarda el nombre del autor
    var estado: EstadoLibro = .disponible // inicia cada libro como disponible y permite cambiar su estado
} // termina la declaracion del struct

class Biblioteca { // representa una sola biblioteca compartida como tipo por referencia
    var libros: [Libro] = [] // crea un array vacio donde se guardaran los libros

    func agregar(libro: Libro) { // recibe un libro para registrarlo en la biblioteca
        libros.append(libro) // agrega el libro recibido al final del array
    } // termina el metodo agregar

    func prestar(titulo: String) -> Bool { // busca por titulo e informa si el prestamo fue posible
        for i in 0..<libros.count { // recorre todas las posiciones validas del array mediante su indice
            if libros[i].titulo == titulo { // comprueba si el libro de la posicion actual tiene el titulo buscado
                if libros[i].estado == .disponible { // verifica que el libro encontrado pueda prestarse
                    libros[i].estado = .prestado // modifica el struct directamente dentro del array
                    print("Préstamo aprobado: \(titulo)") // informa que el prestamo fue realizado
                    return true // termina el metodo indicando que la operacion fue exitosa
                } else { // se ejecuta cuando el libro encontrado ya esta prestado
                    print("Error: \(titulo) ya está prestado") // explica por que no se puede volver a prestar
                    return false // termina el metodo indicando que la operacion fallo
                } // termina la verificacion del estado
            } // termina la comparacion del titulo
        } // termina el recorrido del array
        print("Error: no existe \(titulo)") // informa que ningun libro coincide con el titulo solicitado
        return false // indica que no fue posible realizar el prestamo
    } // termina el metodo prestar

    func devolver(titulo: String) -> Bool { // busca por titulo e informa si la devolucion fue posible
        for i in 0..<libros.count { // recorre el array usando indices para poder modificar el elemento
            if libros[i].titulo == titulo { // comprueba si encontro el titulo solicitado
                if libros[i].estado == .prestado { // verifica que el libro realmente estuviera prestado
                    libros[i].estado = .disponible // cambia directamente el estado del libro guardado en el array
                    print("Devolución registrada: \(titulo)") // confirma que la devolucion fue registrada
                    return true // indica que la devolucion termino correctamente
                } else { // se ejecuta si el libro encontrado ya estaba disponible
                    print("Error: \(titulo) ya está disponible") // informa que no corresponde devolverlo
                    return false // indica que la operacion no pudo realizarse
                } // termina la verificacion del estado
            } // termina la comparacion del titulo
        } // termina el recorrido del array
        print("Error: no existe \(titulo)") // informa que el titulo no esta registrado
        return false // indica que no se pudo realizar la devolucion
    } // termina el metodo devolver

    func inventario() { // muestra todos los libros y su estado actual
        print("===== INVENTARIO =====") // imprime un encabezado para ordenar la salida
        for libro in libros { // recorre cada libro almacenado sin necesitar modificarlo
            var textoEstado = "" // prepara un texto simple para mostrar el estado
            switch libro.estado { // evalua los casos definidos en EstadoLibro
            case .disponible: // se ejecuta cuando el libro puede prestarse
                textoEstado = "disponible" // convierte el estado disponible en texto
            case .prestado: // se ejecuta cuando el libro esta prestado
                textoEstado = "prestado" // convierte el estado prestado en texto
            } // termina el switch despues de cubrir sus dos casos
            print("\(libro.titulo) (\(libro.autor)) - \(textoEstado)") // imprime titulo, autor y estado del libro
        } // termina el recorrido de los libros
    } // termina el metodo inventario
} // termina la clase Biblioteca

let biblioteca = Biblioteca() // crea la unica biblioteca que se usara en la simulacion
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez")) // agrega el primer libro disponible
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa")) // agrega el segundo libro disponible
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes")) // agrega el tercer libro disponible
biblioteca.prestar(titulo: "La ciudad y los perros") // presta correctamente el segundo libro
biblioteca.prestar(titulo: "La ciudad y los perros") // intenta prestar otra vez el mismo libro
biblioteca.devolver(titulo: "La ciudad y los perros") // devuelve el segundo libro
biblioteca.prestar(titulo: "El Quijote") // presta correctamente el tercer libro
biblioteca.prestar(titulo: "El Principito") // intenta prestar un libro que no existe
biblioteca.inventario() // presenta el inventario final solicitado
