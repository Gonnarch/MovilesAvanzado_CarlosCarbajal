import Foundation

enum ErrorEntrada: LocalizedError {
    case mensaje(String)
    var errorDescription: String? { if case .mensaje(let texto) = self { return texto }; return nil }
}
enum Entrada {
    static func numero(_ texto: String, _ nombre: String, min: Double = 0, max: Double = 1e12) throws -> Double {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
        guard let valor = Double(limpio), valor.isFinite, valor >= min, valor <= max else {
            throw ErrorEntrada.mensaje("\(nombre): ingresa un número entre \(min) y \(max). No uses separadores de miles.")
        }
        return valor
    }
    static func entero(_ texto: String, _ nombre: String, min: Int = 0, max: Int = 100000) throws -> Int {
        let v = try numero(texto, nombre, min: Double(min), max: Double(max))
        guard v.rounded() == v else { throw ErrorEntrada.mensaje("\(nombre): debe ser entero.") }
        return Int(v)
    }
    static func dinero(_ v: Double) -> Double { (v * 100).rounded(.toNearestOrAwayFromZero) / 100 }
    static func soles(_ v: Double) -> String { String(format: "S/ %.2f", v) }
}

import Foundation
enum RegimenCTS: String, CaseIterable, Identifiable {
    case general = "General 728"
    case pequena = "Pequeña REMYPE"
    case micro = "Micro REMYPE"
    case hogar = "Hogar"
    case agrario = "Agrario prorrateado"
    case cas = "CAS"
    case publico = "Público 276"
    case civil = "Construcción civil"
    case otros = "Otros"
    var id: String { rawValue }
}
struct DatosCTS {
    var regimen: RegimenCTS = .general
    var confirmado = true
    var mesMinimo = true
    var jornada = true
    var ria = false
    var cese = false
    var principalVariable = false
    var meses = 6.0, dias = 0.0, ausencias = 0.0
    var base = 3000.0, familiar = 0.0, fijos = 0.0
    var gratificacion = 3000.0, semestrales = 0.0, anuales = 0.0
    var principalTotal = 18000.0, diasPromedio = 180.0
    var variables = [0.0, 0, 0, 0, 0, 0]
    var diasTopeRestantes = 90.0
    var basicaAgraria = 1230.0, diasAgrarios = 30.0
}
struct ResultadoCTS {
    let estado: String
    let importe: Double?
    let detalle: String
    var rc: Double? = nil
    var diasNetos: Double? = nil
}
enum CTSModelo {
    static func calcular(_ d: DatosCTS) throws -> ResultadoCTS {
        guard d.confirmado else { return ResultadoCTS(estado: "REVISAR", importe: nil, detalle: "Confirma el régimen aplicable, la jornada y el historial. REMYPE no depende solo del tamaño de la empresa.") }
        if [.cas, .publico, .civil, .otros].contains(d.regimen) {
            return ResultadoCTS(estado: "REVISAR", importe: nil, detalle: "Régimen con reglas propias. Consulta la matriz normativa; no equivale a CTS cero. CAS tiene cambios en 2026.")
        }
        if d.regimen == .agrario {
            guard d.basicaAgraria.isFinite, d.diasAgrarios.isFinite, d.basicaAgraria > 0,
                  d.diasAgrarios >= 0, d.diasAgrarios <= 31, d.diasAgrarios.rounded() == d.diasAgrarios else {
                throw ErrorEntrada.mensaje("Agrario: básica mensual positiva y días pagables enteros de 0 a 31.")
            }
            return ResultadoCTS(estado: "COMPONENTE", importe: Entrada.dinero(d.basicaAgraria * 0.0972 / 30 * d.diasAgrarios), detalle: "Solo componente CTS prorrateado de la RB validada. No volver a depositarlo como CTS general. No liquida toda la planilla agraria.")
        }
        if d.regimen == .micro { return ResultadoCTS(estado: "SIN DERECHO", importe: 0, detalle: "Solo microempresa válidamente acogida y trabajador comprendido en el régimen especial; derechos anteriores requieren régimen general.") }
        if d.ria { return ResultadoCTS(estado: "INCLUIDA EN RIA", importe: nil, detalle: "Verificar convenio de remuneración integral anual y su inclusión de CTS. No duplicar el pago.") }
        if !d.jornada { return ResultadoCTS(estado: "REVISAR JORNADA", importe: nil, detalle: "General exige jornada promedio de 4 horas. Validar jornada, régimen y posibles condiciones más favorables.") }
        if !d.mesMinimo { return ResultadoCTS(estado: d.cese ? "SIN MES MÍNIMO" : "ACUMULAR", importe: nil, detalle: "Sin mes mínimo de vínculo: si continúa, trasladar el tiempo al siguiente período. No confundir con días netos después de ausencias.") }
        let valores = [d.meses,d.dias,d.ausencias,d.base,d.familiar,d.fijos,d.gratificacion,d.semestrales,d.anuales] + d.variables
        guard valores.allSatisfy({ $0.isFinite && $0 >= 0 }), d.variables.count == 6,
              d.meses <= 6, d.meses.rounded() == d.meses, d.dias < 30, d.dias.rounded() == d.dias,
              d.ausencias.rounded() == d.ausencias else { throw ErrorEntrada.mensaje("Revisa importes y tiempo: meses 0–6, días 0–29 y ausencias enteras no negativas.") }
        let periodo = d.meses * 30 + d.dias
        guard periodo > 0, periodo <= 180, d.ausencias <= periodo else { throw ErrorEntrada.mensaje("El período debe tener 1–180 días convencionales y las ausencias no pueden excederlo.") }
        if d.principalVariable {
            guard d.principalTotal.isFinite, d.principalTotal >= 0, d.diasPromedio.isFinite,
                  d.diasPromedio > 0, d.diasPromedio <= 184, d.diasPromedio.rounded() == d.diasPromedio else {
                throw ErrorEntrada.mensaje("Principal variable: total no negativo y divisor diario validado de 1 a 184.")
            }
        }
        let principal = d.principalVariable ? d.principalTotal / d.diasPromedio * 30 : d.base
        // Cada casilla corresponde al MISMO concepto complementario en un mes diferente.
        // Para período incompleto, art. 6 DS 004-97-TR: dividir entre el período a liquidar.
        let variable = d.variables.filter { $0 > 0 }.count >= 3 ? d.variables.reduce(0,+) / (periodo / 30) : 0
        let rc = principal + d.familiar + d.fijos + variable + d.gratificacion / 6 + d.semestrales / 6 + d.anuales / 12
        let netos = periodo - d.ausencias
        var importe = rc * netos / 360
        if d.regimen == .pequena {
            guard d.diasTopeRestantes.isFinite, d.diasTopeRestantes >= 0, d.diasTopeRestantes <= 90 else {
                throw ErrorEntrada.mensaje("Valida el saldo del tope de pequeña empresa: 0 a 90 remuneraciones diarias.")
            }
            importe = min(importe * 0.5, rc / 30 * d.diasTopeRestantes)
        }
        return ResultadoCTS(estado: "CALCULADO", importe: Entrada.dinero(importe), detalle: "RC × días netos / 360" + (d.regimen == .pequena ? " × 0.5, limitado al saldo validado del tope." : "."), rc: rc, diasNetos: netos)
    }
}
enum CTSAutomatizacion {
    static func periodo(anio: Int, noviembre: Bool) throws -> (inicio: String, fin: String) {
        guard (1902...2099).contains(anio) else { throw ErrorEntrada.mensaje("Año de depósito entre 1902 y 2099.") }
        return noviembre ? ("\(anio)-05-01", "\(anio)-10-31") : ("\(anio-1)-11-01", "\(anio)-04-30")
    }
    static func estimar(sueldo: Double, familiar: Double, fijos: Double, meses: Double, ausencias: Double, regimen: RegimenCTS) throws -> Double {
        guard [sueldo,familiar,fijos].allSatisfy({ $0.isFinite && $0 >= 0 }) else {
            throw ErrorEntrada.mensaje("Sueldo y conceptos históricos deben ser no negativos.")
        }
        return try gratificacion(rc: sueldo + familiar + fijos, meses: meses, ausencias: ausencias, regimen: regimen, confirmado: true)
    }
    static var calendario: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c
    }
    static func fecha(_ texto: String) throws -> Date {
        let f = DateFormatter(); f.calendar = calendario; f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = calendario.timeZone; f.dateFormat = "yyyy-MM-dd"; f.isLenient = false
        guard let d = f.date(from: texto), f.string(from: d) == texto else {
            throw ErrorEntrada.mensaje("Fecha inválida. Usa AAAA-MM-DD, por ejemplo 2026-05-01.")
        }
        return d
    }
    static func tiempo(ingreso: String, inicio: String, corte: String) throws -> (meses: Double, dias: Double, minimo: Bool) {
        let c = calendario
        let i = try fecha(ingreso), s = try fecha(inicio), e = try fecha(corte)
        let sm = c.component(.month, from: s)
        guard i >= (try fecha("1901-01-01")), e <= (try fecha("2100-12-31")), i <= e,
              c.component(.day, from: s) == 1, [5,11].contains(sm), e >= s,
              e < c.date(byAdding: .month, value: 6, to: s)! else {
            throw ErrorEntrada.mensaje("Fechas: ingreso ≤ corte y corte dentro de un semestre que empieza el 1 de mayo o noviembre.")
        }
        let b = max(i,s), bd = c.component(.day, from: b), ed = c.component(.day, from: e)
        let ultimo = c.range(of: .day, in: .month, for: e)!.count
        guard bd != 31, !(c.component(.month, from: b) == 2 && bd != 1),
              !(c.component(.month, from: e) == 2 && ed != ultimo) else {
            throw ErrorEntrada.mensaje("REVISAR FECHAS: inicio día 31 o febrero parcial. Usa meses/días manuales validados.")
        }
        let diferencia = (c.component(.year, from: e)-c.component(.year, from: b))*12 + c.component(.month, from: e)-c.component(.month, from: b)
        let dias = diferencia*30 + (ed == ultimo ? 30 : min(30,ed)) - bd + 1
        let minimo = c.date(byAdding: .month, value: 1, to: i)! <= c.date(byAdding: .day, value: 1, to: e)!
        return (Double(dias/30),Double(dias%30),minimo)
    }
    static func gratificacion(rc: Double, meses: Double, ausencias: Double, regimen: RegimenCTS, confirmado: Bool) throws -> Double {
        guard [rc,meses,ausencias].allSatisfy({$0.isFinite && $0 >= 0}), meses <= 6,
              meses.rounded() == meses, ausencias.rounded() == ausencias, ausencias <= meses*30 else {
            throw ErrorEntrada.mensaje("Gratificación: base no negativa, meses calendario completos 0–6 y ausencias enteras hasta meses × 30.")
        }
        guard [.general,.pequena,.hogar].contains(regimen) else { throw ErrorEntrada.mensaje("Revisar régimen de gratificación.") }
        guard confirmado else { throw ErrorEntrada.mensaje("CONFIRMAR PERCIBIDO: verifica coincidencia con boleta; si difiere, ingresa el monto real en modo manual.") }
        return Entrada.dinero(rc*(meses/6-ausencias/180)*(regimen == .pequena ? 0.5 : 1))
    }
}


import Foundation
struct ResultadoNotas {
    let promedio: Double
    let redondeado: Int
    let indiceEliminado: Int?
    let cantidad: Int
}
enum NotasModelo {
    // Interpretación explícita: AN equivale a cero y nunca es eliminable.
    static func calcular(_ textos: [String]) throws -> ResultadoNotas {
        guard textos.count == 4 else { throw ErrorEntrada.mensaje("Se requieren exactamente cuatro notas.") }
        var notas: [Double] = []
        var anuladas: [Bool] = []
        for (i, texto) in textos.enumerated() {
            let an = texto.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == "AN"
            anuladas.append(an)
            if an { notas.append(0) }
            else { notas.append(try Entrada.numero(texto, "Nota \(i+1)", max: 20)) }
        }
        let elegibles = notas.indices.filter { !anuladas[$0] }
        // En empate se elimina la primera nota numérica mínima, solo una.
        let quitar = elegibles.min { notas[$0] == notas[$1] ? $0 < $1 : notas[$0] < notas[$1] }
        let cantidad = quitar == nil ? 4 : 3
        let suma = notas.enumerated().filter { $0.offset != quitar }.reduce(0) { $0 + $1.element }
        let promedio = suma / Double(cantidad)
        return ResultadoNotas(promedio: promedio, redondeado: Int(promedio.rounded(.toNearestOrAwayFromZero)), indiceEliminado: quitar, cantidad: cantidad)
    }
}

import Foundation
enum PesoModelo {
    static func calcular(altura: String, edad: String, mujer: Bool) throws -> Double {
        let h = try Entrada.numero(altura, "Altura en cm", min: 1, max: 300)
        if !edad.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            _ = try Entrada.entero(edad, "Edad", min: 1, max: 120)
        }
        let r = (mujer ? 45.5 : 50) + 0.9 * (h - 152)
        guard r > 0 else { throw ErrorEntrada.mensaje("La fórmula produce un resultado no válido para esa altura.") }
        return r
    }
}

import Foundation
enum PagoModelo {
    static func impuestoAnual(_ ingreso: Double, uit: Double) -> Double {
        var exceso = max(0, ingreso - 7 * uit), impuesto = 0.0
        for (amplitud, tasa) in [(5.0,0.08),(15.0,0.14),(15.0,0.17),(10.0,0.20)] {
            let tramo = min(exceso, amplitud * uit); impuesto += tramo * tasa; exceso -= tramo
        }
        return impuesto + exceso * 0.30
    }
    static func retencion(ingreso: Double, uit: Double, mes: Int, retenido: Double, extraordinario: Double) -> Double {
        let divisor = mes <= 3 ? 12.0 : mes == 4 ? 9 : mes <= 7 ? 8 : mes == 8 ? 5 : mes <= 11 ? 4 : 1
        let anual = impuestoAnual(ingreso, uit: uit)
        let ordinaria = max(0, (anual - (mes <= 3 ? 0 : retenido)) / divisor)
        let adicional = impuestoAnual(ingreso + extraordinario, uit: uit) - anual
        return Entrada.dinero(ordinaria + adicional)
    }
}
