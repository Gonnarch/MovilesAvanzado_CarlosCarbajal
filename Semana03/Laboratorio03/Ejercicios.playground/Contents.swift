// Desarrollado por: [TU NOMBRE]
import Foundation
// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = []
for i in 1...5 {
print("Nombre del alumno \(i):")
let nombre = readLine() ?? ""
alumnos.append(nombre)
}
print("Alumnos: \(alumnos)")


// ===== TODO 2: Buscar un alumno =====
print("Buscar alumno:")
let buscar = readLine() ?? ""
if alumnos.contains(buscar) {
print("\(buscar) está en la lista")
} else {
print("\(buscar) NO está en la lista")
}


// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = []
for i in 1...5 {
print("Nota del alumno \(i):")
let n = Double(readLine() ?? "") ?? 0
notasClase.append(n)
}
var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0
for nota in notasClase {
sumaNotas += nota
if nota >= 13 {
aprobados += 1
} else {
desaprobados += 1
}
}
print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")

// ===== FIX: 3 errores =====

// FIX 1:
// El Array contiene String, por eso se agrega una fruta como texto.
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Manzana")

// FIX 2:
// Se cambia let por var porque el Array será modificado.
var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")

// FIX 3:
// El Array tiene índices del 0 al 4.
let numeros = [10, 20, 30, 40, 50]
print(numeros[4])


// ===== PREDICT =====

var lista = [1, 2, 3, 4, 5]

lista.remove(at: 0)
lista.append(6)

print(lista)       // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]

print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres)          // PREDICT 4: ["Ana", "Carlos", "Beto"]



// =====================================
// EJERCICIO 2: DICCIONARIOS
// =====================================

// ===== TODO 4: Catálogo de productos =====

var productos: [String: Double] = [:]

for i in 1...4 {
    print("Producto \(i) - Nombre:")
    let nombre = readLine() ?? ""

    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0

    productos[nombre] = precio
}


// ===== TODO 5: Mostrar catálogo =====

print("===== CATÁLOGO =====")

for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}


// ===== TODO 6: Valor total =====

var valorTotal = 0.0

for (_, precio) in productos {
    valorTotal += precio
}

print("Valor total: S/. \(valorTotal)")


// ===== TODO 7: Buscar producto =====

print("Buscar producto:")
let buscarProd = readLine() ?? ""

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}


// ===== ANALYZE =====

var edades: [String: Int] = [
    "Ana": 20,
    "Luis": 22,
    "María": 19
]

var mayores: [String] = []

for (nombre, edad) in edades {
    if edad >= 21 {
        mayores.append(nombre)
    }
}

print("Mayores de 21: \(mayores)")

// ANALYZE 1:
// Recorre el diccionario de edades.
// Si una persona tiene 21 años o más,
// agrega su nombre al Array "mayores".
// Imprime: Mayores de 21: ["Luis"]




// =====================================
// EJERCICIO 3: SETS
// =====================================

// ===== TODO 8: Eliminar duplicados =====

var numerosSet: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numerosSet.append(n)
}

print("Con duplicados: \(numerosSet)")

let sinDuplicados = Array(Set(numerosSet)).sorted()

print("Sin duplicados: \(sinDuplicados)")


// ===== TODO 9: Comparar asistencia =====

// Pide 4 nombres lunes, 4 martes
// Muestra: ambos días, solo lunes, solo martes

var asistenciaLunes: Set<String> = []
var asistenciaMartes: Set<String> = []

print("===== ASISTENCIA LUNES =====")

for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    asistenciaLunes.insert(nombre)
}

print("===== ASISTENCIA MARTES =====")

for i in 1...4 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    asistenciaMartes.insert(nombre)
}

let ambosDias = asistenciaLunes.intersection(asistenciaMartes)
let soloLunes = asistenciaLunes.subtracting(asistenciaMartes)
let soloMartes = asistenciaMartes.subtracting(asistenciaLunes)

print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")


// ===== PREDICT =====

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))      // PREDICT 5: [4, 5]
print(a.union(b).count)       // PREDICT 6: 8
print(a.subtracting(b))       // PREDICT 7: [1, 2, 3]

var repetidos: Set = ["A", "B", "A", "C", "B"]

print(repetidos.count)        // PREDICT 8: 3


// =====================================
// EJERCICIO 4: COMBINACIÓN DE COLECCIONES
// =====================================

// ===== TODO 10: Inventario de productos =====

var preciosInventario: [String: Double] = [:]
var stocksInventario: [String: Int] = [:]

print("¿Cuántos productos?")

let cantidadProductosInventario = Int(readLine() ?? "") ?? 0

for i in 1...cantidadProductosInventario {

    print("Producto \(i) - Nombre:")
    let nombreProducto = readLine() ?? ""

    print("Precio:")
    let precioProducto = Double(readLine() ?? "") ?? 0

    print("Stock:")
    let stockProducto = Int(readLine() ?? "") ?? 0

    preciosInventario[nombreProducto] = precioProducto
    stocksInventario[nombreProducto] = stockProducto
}


// ===== Calcular valor total =====

var valorTotalInventario = 0.0

for (nombreProducto, precioProducto) in preciosInventario {

    if let stockProducto = stocksInventario[nombreProducto] {

        let subtotalProducto = precioProducto * Double(stockProducto)

        valorTotalInventario += subtotalProducto
    }
}

print("Valor total del inventario: S/. \(valorTotalInventario)")


// ===== Mostrar productos con stock bajo =====

print("===== PRODUCTOS CON STOCK BAJO =====")

for (nombreProducto, stockProducto) in stocksInventario {

    if stockProducto < 5 {
        print("\(nombreProducto) - Stock: \(stockProducto)")
    }
}x
