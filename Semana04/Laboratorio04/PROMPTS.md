# Prompts utilizados - Laboratorio 04

## Herramienta de IA utilizada

ChatGPT.

## Caso 2B - Biblioteca

### Prompt 1

Soy estudiante de Swift de cuarta semana y trabajo en un Playground de Xcode. Necesito resolver una biblioteca con `enum EstadoLibro`, `struct Libro` y `class Biblioteca`. La clase debe empezar con un array vacío y tener los métodos `agregar(libro:)`, `prestar(titulo:) -> Bool`, `devolver(titulo:) -> Bool` e `inventario()`. La búsqueda debe realizarse con `for i in 0..<libros.count`. Solo usa struct, class, enums, arrays, condicionales, bucles y funciones. No uses optionals, `guard let`, `firstIndex(where:)`, closures, `didSet`, propiedades calculadas ni genéricos. Devuelve solamente código Swift y agrega en cada línea un comentario claro que explique qué hace y por qué se usa. La simulación debe producir exactamente la salida indicada por el docente.

### Respuesta de la IA

La IA generó el enum con los estados del libro, el struct con sus datos y la clase con los cuatro métodos pedidos. También agregó tres libros y realizó todas las operaciones de la simulación.

### ¿Funcionó a la primera?

Sí. El código respetó el recorrido por índices y produjo la salida solicitada.

### ¿Usó algo que no hemos visto en clase?

No. La solución usa únicamente enums, structs, clases, arrays, bucles, condicionales, funciones y `switch`.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?

La lógica principal fue casi igual porque las firmas y el tipo de recorrido estaban definidos en el enunciado. La diferencia principal fue que la versión de la IA agregó explicaciones más detalladas en cada línea.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?

Entiendo todas las líneas. La más importante es `libros[i].estado = .prestado`, porque modifica directamente el libro que se encuentra dentro del array.

### ¿Qué me pareció mejor de MI versión?

Mi versión es más corta y resulta más rápida de leer cuando ya se entiende la lógica.

### ¿Qué me pareció mejor de la versión de la IA?

Los comentarios explican con claridad por qué se usa cada estructura y ayudan a repasar los conceptos de POO.
