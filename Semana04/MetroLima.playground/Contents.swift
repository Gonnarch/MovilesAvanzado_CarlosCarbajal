import Foundation

// Semana 04: Playground de consulta del Metro de Lima y Callao.
// Simulación académica: todas las estaciones del mapa están disponibles.
// Clave: número de línea. Valor: arreglo de estaciones en orden de recorrido.
let lineas: [Int: [String]] = [
    1: ["Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
        "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
        "Los Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Nicolás Arriola",
        "Gamarra", "28 de Julio", "Miguel Grau", "El Ángel", "Presbítero Maestro",
        "Caja de Agua", "Pirámide del Sol", "Los Jardines", "Los Postes",
        "San Carlos", "San Martín", "Santa Rosa", "Bayóvar"],
    2: ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
        "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio",
        "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi",
        "Estación Central", "Plaza Manco Cápac", "Cangallo", "28 de Julio",
        "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento",
        "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán",
        "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado",
        "Municipalidad de Ate"],
    3: ["El Álamo", "Huandoy", "2 de Octubre", "Villa Sol", "Naranjal",
        "Carlos Izaguirre", "Tomás Valle", "Bartolomé de las Casas", "José Granda",
        "Caquetá", "Tacna", "Garcilaso de la Vega", "Estación Central",
        "Parque de la Reserva", "Museo de Historia Natural", "César Canevaro",
        "Rivera Navarrete", "Andrés Aramburú", "Huaca Pucllana",
        "Parque Central de Miraflores", "Parque Reducto", "Panamá", "Juana Alarco",
        "Los Cabitos", "Alejandro Velazco", "Las Gardenias", "Los Héroes",
        "Pedro Miotta"],
    4: ["Gambetta", "Canta Callao", "Bocanegra", "Aeropuerto", "El Olivar",
        "Quilca", "Morales Duárez", "Carmen de la Legua", "Venezuela",
        "Rafael Escardó", "Pando", "José de Sucre", "Brasil", "Felipe Salaverry",
        "Guillermo Prescott", "Las Palmeras", "Conde de San Isidro",
        "Pablo Carriquiry", "La Cultura", "San Luis", "Monterrico", "Manuel Olguín",
        "Los Frutales", "La Molina", "Santa Patricia", "Mayorazgo",
        "Mercado Santa Anita"]
]

// Un ID evita confundir estaciones de distintas líneas con el mismo nombre.
struct Estacion {
    let id: String
    let nombre: String
    let linea: Int
    let indice: Int
}

let estaciones: [String: Estacion] = {
    var resultado: [String: Estacion] = [:]
    for numero in lineas.keys.sorted() {
        for (indice, nombre) in (lineas[numero] ?? []).enumerated() {
            let id = "L\(numero)-\(indice + 1)"
            resultado[id] = Estacion(id: id, nombre: nombre, linea: numero, indice: indice)
        }
    }
    return resultado
}()

func normalizar(_ texto: String) -> String {
    texto.folding(options: [.diacriticInsensitive, .caseInsensitive],
                  locale: Locale(identifier: "es_PE"))
        .split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
        .lowercased()
}

func leer(_ mensaje: String) -> String? {
    print(mensaje, terminator: " ")
    return readLine()
}

func numeroLinea(_ texto: String) -> Int? {
    let entrada = normalizar(texto)
    let numero = Int(entrada.hasPrefix("linea ") ? String(entrada.dropFirst(6)) : entrada)
    guard let numero = numero, lineas[numero] != nil else { return nil }
    return numero
}

func listarLineas() {
    for numero in lineas.keys.sorted() {
        guard let nombres = lineas[numero], let inicio = nombres.first,
              let final = nombres.last else { continue }
        print("Línea \(numero): \(inicio) ↔ \(final) | \(nombres.count) estaciones")
    }
}

func consultarLinea() {
    guard let texto = leer("Ingrese una línea (ejemplo: Línea 2):") else { return }
    guard let numero = numeroLinea(texto), let nombres = lineas[numero] else {
        print("Línea inválida. Solo se admiten las líneas 1 a 4.")
        return
    }
    print("\nLÍNEA \(numero) — \(nombres.count) estaciones")
    for (indice, nombre) in nombres.enumerated() {
        print("\(indice + 1). \(nombre)")
    }
}

func ejecutarMenu() {
    print("SIMULACIÓN ACADÉMICA: todas las estaciones se consideran operativas.")
    while true {
        print("\nMETRO DE LIMA Y CALLAO\n1. Listar líneas\n2. Consultar línea\n0. Salir")
        guard let opcion = leer("Seleccione una opción:") else { break }
        switch normalizar(opcion) {
        case "1": listarLineas()
        case "2": consultarLinea()
        case "0": print("Gracias por consultar. Hasta luego."); return
        default: print("Opción inválida. Intente nuevamente.")
        }
    }
    print("\nFin de entrada. Programa finalizado.")
}

if CommandLine.arguments.contains("--menu") {
    ejecutarMenu()
} else {
    listarLineas()
}
