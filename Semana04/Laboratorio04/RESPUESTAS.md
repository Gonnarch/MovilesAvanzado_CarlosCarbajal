# Respuestas del Laboratorio 04

## FIX 7

Faltaba escribir `override` antes de `func descuento()`, porque el método ya está declarado en la clase padre `Sucursal`.

## FIX 8

Faltaba llamar a `super.init(nombre:ciudad:)` después de inicializar `radioKm`, para completar la inicialización de la clase padre.
