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

print("Metro de Lima y Callao — \(lineas.count) líneas cargadas")
