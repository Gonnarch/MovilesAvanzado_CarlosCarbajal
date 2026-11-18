#!/usr/bin/env python3
"""Reproduce las fórmulas de ReglasCompra.swift y comprueba los casos numéricos de la guía.

Uso:  python3 verificar_reglas.py
"""
from datetime import date, timedelta

TASA_IGV = 0.18
LIMITE_APROBACION = 5000.00
DIAS_CREDITO = 30


def redondear(v):
    return round(v + 1e-9, 2)


def subtotal(cantidad, costo):
    return redondear(cantidad * costo)


def igv(sub):
    return redondear(sub * TASA_IGV)


def total(sub, i):
    return redondear(sub + i)


def requiere_aprobacion(t):
    return t >= LIMITE_APROBACION


def costo_promedio(stock, costo_actual, cantidad, costo_unitario):
    nuevo = stock + cantidad
    if nuevo <= 0:
        return costo_actual
    return redondear((stock * costo_actual + cantidad * costo_unitario) / nuevo)


def check(nombre, obtenido, esperado):
    ok = obtenido == esperado
    print(f"[{'OK ' if ok else 'ERR'}] {nombre}: {obtenido} (esperado {esperado})")
    assert ok


print("Caso 3 · 10 a 120.00 al crédito sobre stock 40 / 110.00")
s = subtotal(10, 120.00); i = igv(s); t = total(s, i)
check("subtotal", s, 1200.00)
check("IGV", i, 216.00)
check("total", t, 1416.00)
check("estado", "Pendiente" if requiere_aprobacion(t) else "Aprobada", "Aprobada")
check("stock", 40 + 10, 50)
check("costo promedio", costo_promedio(40, 110.00, 10, 120.00), 112.00)
hoy = date(2026, 11, 17)
check("vence", hoy + timedelta(days=DIAS_CREDITO), date(2026, 12, 17))

print("\nCaso 4 · la misma compra al contado")
al_credito = False
pagada = not al_credito
check("pagada", pagada, True)
check("aparece en Pendientes de pago", al_credito and not pagada, False)

print("\nCaso 5 · 50 a 120.00")
s = subtotal(50, 120.00); i = igv(s); t = total(s, i)
check("total", t, 7080.00)
check("estado", "Pendiente" if requiere_aprobacion(t) else "Aprobada", "Pendiente")
check("stock sin cambio", 40, 40)

print("\nCaso 6 · el supervisor aprueba la compra del caso 5")
check("stock", 40 + 50, 90)
check("costo promedio", costo_promedio(40, 110.00, 50, 120.00), 115.56)

print("\nLímite de aprobación")
check("4,999.99 -> Aprobada", requiere_aprobacion(4999.99), False)
check("5,000.00 -> Pendiente", requiere_aprobacion(5000.00), True)

print("\nCierre conjunto de IGV (ejemplo del docente)")
saldo = redondear(734.10 - 2361.60)
check("IGV ventas - crédito fiscal", saldo, -1627.50)

print("\nTodos los casos numéricos coinciden.")
