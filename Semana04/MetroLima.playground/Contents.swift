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

// Pares explícitos de la simulación; nunca inferimos una conexión por nombre igual.
let paresTransbordo: [(String, String)] = [
    ("L1-16", "L2-16"), // 28 de Julio
    ("L1-10", "L3-24"), // Los Cabitos
    ("L1-13", "L4-19"), // La Cultura
    ("L2-5", "L4-8"),   // Carmen de la Legua
    ("L2-13", "L3-13"), // Estación Central
    ("L2-24", "L4-27"), // Mercado Santa Anita
    ("L3-17", "L4-17")  // Rivera Navarrete / Conde de San Isidro
]

// Diccionario de adyacencia: cada transbordo se puede realizar en ambos sentidos.
let conexiones: [String: [String]] = {
    var resultado: [String: [String]] = [:]
    for (origen, destino) in paresTransbordo {
        resultado[origen, default: []].append(destino)
        resultado[destino, default: []].append(origen)
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

// Se ordena explícitamente: los diccionarios no garantizan orden de recorrido.
func buscarEstaciones(_ texto: String) -> [Estacion] {
    let consulta = normalizar(texto)
    guard !consulta.isEmpty else { return [] }
    return estaciones.values.filter { normalizar($0.nombre).contains(consulta) }
        .sorted { a, b in a.linea == b.linea ? a.indice < b.indice : a.linea < b.linea }
}

func mostrarCoincidencias(_ resultados: [Estacion]) {
    for (indice, estacion) in resultados.enumerated() {
        print("\(indice + 1). \(estacion.nombre) — Línea \(estacion.linea) [\(estacion.id)]")
    }
}

func seleccionarEstacion() -> Estacion? {
    guard let texto = leer("Nombre de estación (ejemplo: Grau):") else { return nil }
    guard !normalizar(texto).isEmpty else {
        print("Ingrese un nombre; la búsqueda no puede estar vacía.")
        return nil
    }
    let resultados = buscarEstaciones(texto)
    guard !resultados.isEmpty else {
        print("No se encontraron estaciones.")
        return nil
    }
    if resultados.count == 1 { return resultados[0] }
    mostrarCoincidencias(resultados)
    guard let respuesta = leer("Seleccione el número del resultado (0 para cancelar):"),
          let numero = Int(respuesta.trimmingCharacters(in: .whitespacesAndNewlines)) else {
        print("Selección inválida o fin de entrada.")
        return nil
    }
    if numero == 0 { return nil }
    guard (1...resultados.count).contains(numero) else {
        print("Selección fuera de rango.")
        return nil
    }
    return resultados[numero - 1]
}

func mostrarDetalle(_ estacion: Estacion) {
    guard let nombres = lineas[estacion.linea] else { return }
    print("\nESTACIÓN: \(estacion.nombre)")
    print("Línea: \(estacion.linea) | ID interno: \(estacion.id)")
    print("Posición: \(estacion.indice + 1) de \(nombres.count)")
    let anterior = estacion.indice > 0 ? nombres[estacion.indice - 1] : "No tiene (inicio de línea)"
    let siguiente = estacion.indice + 1 < nombres.count ? nombres[estacion.indice + 1] : "No tiene (final de línea)"
    print("Anterior: \(anterior)\nSiguiente: \(siguiente)")
    mostrarTransbordos(estacion)
}

func mostrarTransbordos(_ estacion: Estacion) {
    let destinos = conexiones[estacion.id] ?? []
    if destinos.isEmpty {
        print("Sin transbordos registrados en esta simulación.")
        return
    }
    print("Transbordos de la simulación:")
    for id in destinos {
        guard let destino = estaciones[id] else { continue }
        print("→ Línea \(destino.linea), estación \(destino.nombre)")
    }
}

func listarConexiones() {
    print("\nCONEXIONES DE LA SIMULACIÓN (no son información de servicio actual)")
    for (origen, destino) in paresTransbordo {
        guard let a = estaciones[origen], let b = estaciones[destino] else { continue }
        print("\(a.nombre) (L\(a.linea)) ↔ \(b.nombre) (L\(b.linea))")
    }
}

func filtrarEstaciones() {
    guard let texto = leer("Ingrese parte del nombre:") else { return }
    guard !normalizar(texto).isEmpty else {
        print("El filtro no puede estar vacío.")
        return
    }
    let resultados = buscarEstaciones(texto)
    print("Coincidencias: \(resultados.count)")
    mostrarCoincidencias(resultados)
}

func ejecutarMenu() {
    print("SIMULACIÓN ACADÉMICA: todas las estaciones se consideran operativas.")
    while true {
        print("\nMETRO DE LIMA Y CALLAO\n1. Listar líneas\n2. Consultar línea\n3. Consultar estación\n4. Filtrar estaciones\n5. Listar conexiones\n6. Consultar transbordos de una estación\n0. Salir")
        guard let opcion = leer("Seleccione una opción:") else { break }
        switch normalizar(opcion) {
        case "1": listarLineas()
        case "2": consultarLinea()
        case "3": if let estacion = seleccionarEstacion() { mostrarDetalle(estacion) }
        case "4": filtrarEstaciones()
        case "5": listarConexiones()
        case "6": if let estacion = seleccionarEstacion() { mostrarTransbordos(estacion) }
        case "0": print("Gracias por consultar. Hasta luego."); return
        default: print("Opción inválida. Intente nuevamente.")
        }
    }
    print("\nFin de entrada. Programa finalizado.")
}

// Pruebas reproducibles: ejecutar con el argumento --pruebas.
// precondition también funciona con la optimización normal de Release.
func ejecutarPruebas() {
    precondition(lineas.keys.sorted() == [1, 2, 3, 4])
    precondition(lineas[1]?.count == 27 && lineas[2]?.count == 27)
    precondition(lineas[3]?.count == 28 && lineas[4]?.count == 27)
    precondition(estaciones.count == 109)
    precondition(normalizar("  LÍNEA   2 ") == "linea 2")
    precondition(numeroLinea("LÍNEA 2") == 2 && numeroLinea(" 4 ") == 4)
    precondition(numeroLinea("5") == nil && numeroLinea("2abc") == nil)
    precondition(numeroLinea("") == nil && numeroLinea("Línea 2 Línea 2") == nil)
    precondition(buscarEstaciones("GRAU").map { $0.nombre } == ["Miguel Grau"])
    precondition(buscarEstaciones("bayovar").count == 1)
    precondition(buscarEstaciones("Santa").count == 5)
    precondition(buscarEstaciones("Mercado Santa Anita").count == 2)
    precondition(buscarEstaciones("   ").isEmpty && buscarEstaciones("zzzz").isEmpty)
    for numero in lineas.keys.sorted() {
        guard let nombres = lineas[numero] else { preconditionFailure("Línea ausente") }
        precondition(Set(nombres.map { normalizar($0) }).count == nombres.count)
        for (indice, nombre) in nombres.enumerated() {
            let registro = estaciones["L\(numero)-\(indice + 1)"]
            precondition(registro?.nombre == nombre && registro?.indice == indice)
        }
    }
    precondition(paresTransbordo.count == 7 && conexiones.count == 14)
    for (origen, destino) in paresTransbordo {
        guard let a = estaciones[origen], let b = estaciones[destino] else {
            preconditionFailure("El transbordo contiene un ID inexistente")
        }
        precondition(a.linea != b.linea)
        precondition(conexiones[origen]?.contains(destino) == true)
        precondition(conexiones[destino]?.contains(origen) == true)
    }
    precondition(conexiones["L1-17"] == nil) // Miguel Grau no es transbordo.
    precondition(conexiones["L1-16"] == ["L2-16"])
    precondition(conexiones["L3-17"] == ["L4-17"])
    print("OK: catálogo, normalización, búsqueda y transbordos verificados.")
}

// En Xcode se ejecutan ejemplos sin pedir entrada interactiva.
// Para escribir consultas: swift MetroLima.playground/Contents.swift --menu
func ejecutarEjemplos() {
    print("METRO DE LIMA — EJEMPLOS DEL PLAYGROUND")
    listarLineas()
    print("\nEstaciones de la línea 2:")
    for (indice, nombre) in (lineas[2] ?? []).enumerated() {
        print("\(indice + 1). \(nombre)")
    }
    print("\nConsulta: Grau")
    if let estacion = buscarEstaciones("Grau").first { mostrarDetalle(estacion) }
    print("\nFiltro: Santa")
    mostrarCoincidencias(buscarEstaciones("Santa"))
    listarConexiones()
}

if CommandLine.arguments.contains("--pruebas") {
    ejecutarPruebas()
} else if CommandLine.arguments.contains("--menu") {
    ejecutarMenu()
} else {
    ejecutarEjemplos()
}
