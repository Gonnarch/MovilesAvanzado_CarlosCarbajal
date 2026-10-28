import SwiftUI
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

struct CTSView: View {
    @State private var porFechas = true, gratiConfirmada = false
    @State private var modoGrati = "Estimada"
    @State private var noviembre = true, anioDeposito = "2026"
    @State private var familiarHistorica = "0", fijosHistoricos = "0"
    @State private var ingreso = "2026-01-01", inicio = "2026-05-01", corte = "2026-10-31"
    @State private var rcGrati = "3000", mesesGrati = "6", faltasGrati = "0"
    @State private var regimen: RegimenCTS = .general
    @State private var confirmado = true
    @State private var mesMinimo = true
    @State private var jornada = true
    @State private var ria = false
    @State private var cese = false
    @State private var principalVariable = false
    @State private var campos = ["meses":"6","dias":"0","ausencias":"0","base":"3000","familiar":"0","fijos":"0","gratificacion":"3000","semestrales":"0","anuales":"0","principalTotal":"18000","diasPromedio":"180","tope":"90","agraria":"1230","diasAgrarios":"30"]
    @State private var variables = ["0","0","0","0","0","0"]
    private func campo(_ id: String, _ nombre: String) -> some View {
        Campo(nombre: nombre, texto: Binding(get: { campos[id] ?? "" }, set: { campos[id] = $0 }))
    }
    private func gratificacionActual() throws -> Double {
        if modoGrati == "Percibida" { return try Entrada.numero(campos["gratificacion"] ?? "", "Gratificación percibida") }
        let meses = try Entrada.numero(mesesGrati, "Meses de gratificación")
        let faltas = try Entrada.numero(faltasGrati, "Días no computables de gratificación")
        if modoGrati == "Histórica" {
            return try CTSAutomatizacion.gratificacion(rc: Entrada.numero(rcGrati, "RC histórica"), meses: meses, ausencias: faltas, regimen: regimen, confirmado: gratiConfirmada)
        }
        guard !principalVariable else { throw ErrorEntrada.mensaje("Principal variable: usa gratificación Percibida o Histórica sustentada.") }
        return try CTSAutomatizacion.estimar(sueldo: Entrada.numero(campos["base"] ?? "", "Sueldo"),
            familiar: Entrada.numero(familiarHistorica, "Asignación familiar histórica"),
            fijos: Entrada.numero(fijosHistoricos, "Fijos históricos"), meses: meses, ausencias: faltas, regimen: regimen)
    }
    private func datos() throws -> DatosCTS {
        var d = DatosCTS(); d.regimen = regimen; d.confirmado = confirmado; d.mesMinimo = mesMinimo
        d.jornada = jornada; d.ria = ria; d.cese = cese; d.principalVariable = principalVariable
        func n(_ k: String) throws -> Double { try Entrada.numero(campos[k] ?? "", k) }
        if !confirmado || [.cas,.publico,.civil,.otros,.micro].contains(regimen) { return d }
        if regimen == .agrario { d.basicaAgraria = try n("agraria"); d.diasAgrarios = try n("diasAgrarios"); return d }
        if ria || !jornada { return d }
        if porFechas {
            let periodo = try CTSAutomatizacion.periodo(anio: Entrada.entero(anioDeposito, "Año", min: 1902, max: 2099), noviembre: noviembre)
            let t = try CTSAutomatizacion.tiempo(ingreso: ingreso, inicio: periodo.inicio, corte: cese ? corte : periodo.fin)
            d.meses = t.meses; d.dias = t.dias; d.mesMinimo = t.minimo
        } else { d.meses = try n("meses"); d.dias = try n("dias") }
        if !d.mesMinimo { return d }
        d.ausencias = try n("ausencias")
        if principalVariable { d.base = 0 } else { d.base = try n("base") }
        d.familiar = try n("familiar"); d.fijos = try n("fijos")
        d.gratificacion = try gratificacionActual()
        d.semestrales = try n("semestrales"); d.anuales = try n("anuales")
        if principalVariable { d.principalTotal = try n("principalTotal"); d.diasPromedio = try n("diasPromedio") }
        d.variables = try variables.enumerated().map { try Entrada.numero($0.element, "Variable mes \($0.offset+1)") }
        if regimen == .pequena { d.diasTopeRestantes = try n("tope") }
        return d
    }
    var body: some View {
        Form {
            Section("Resultado · ejemplo editable") {
                switch Result(catching: { try CTSModelo.calcular(datos()) }) {
                case .success(let r):
                    Text(r.estado).font(.headline)
                    if let importe = r.importe { Text(Entrada.soles(importe)).font(.largeTitle).bold() }
                    if let rc = r.rc { Text("Remuneración computable: \(Entrada.soles(rc))") }
                    if let dias = r.diasNetos { Text("Días equivalentes para CTS: \(Int(dias))") }
                    Aviso(texto: r.detalle)
                case .failure(let e): Text(e.localizedDescription).foregroundStyle(.red)
                }
            }
            Section("Situación laboral") {
                Picker("Régimen", selection: $regimen) { ForEach(RegimenCTS.allCases) { Text($0.rawValue).tag($0) } }
                Toggle("Régimen e historial verificados", isOn: $confirmado)
                Aviso(texto: "Los valores iniciales son un ejemplo. Antes de usar datos reales, verifica contrato, REMYPE, ingresos y tiempo computable. Corte de investigación: 27/10/2026.")
            }
            if regimen == .agrario {
                Section("Componente prorrateado") { campo("agraria","Básica mensual validada"); campo("diasAgrarios","Días pagables de la RB") }
            } else if [.general,.pequena,.hogar].contains(regimen) {
                Section("Condiciones") {
                    if !porFechas { Toggle("Mes mínimo de vínculo cumplido", isOn: $mesMinimo) }
                    Toggle("Jornada con derecho a CTS verificada", isOn: $jornada)
                    Toggle("CTS incluida en convenio RIA", isOn: $ria)
                    Toggle("Cálculo al cese", isOn: $cese)
                }
                Section("Tiempo validado del período") {
                    Toggle("Calcular tiempo desde fechas", isOn: $porFechas)
                    if porFechas {
                        TextField("Ingreso AAAA-MM-DD", text: $ingreso)
                        Campo(nombre: "Año del depósito", texto: $anioDeposito)
                        Picker("Depósito", selection: $noviembre) { Text("Mayo").tag(false); Text("Noviembre").tag(true) }
                        if cese { TextField("Cese AAAA-MM-DD", text: $corte) }
                        if let p = try? CTSAutomatizacion.periodo(anio: Entrada.entero(anioDeposito,"Año",min:1902,max:2099),noviembre:noviembre) {
                            Text("Semestre: \(p.inicio) a \(p.fin)").font(.footnote)
                        }
                        Aviso(texto: "Incluye ambos extremos. Inicio semestral: 1 mayo o 1 noviembre. Febrero parcial, inicio día 31 y arrastres requieren revisión manual. Corte futuro = proyección.")
                    } else { campo("meses","Meses completos (0–6)"); campo("dias","Días adicionales (0–29)") }
                    campo("ausencias","Días NO computables")
                    Aviso(texto: "No restar vacaciones, maternidad ni licencias remuneradas. Enfermedad: revisar el límite legal y el año de cómputo. Mes = 30 días; semestre = 180.")
                }
                Section("Remuneración") {
                    Toggle("Principal variable: comisión o destajo", isOn: $principalVariable)
                    if principalVariable { campo("principalTotal","Total principal del período"); campo("diasPromedio","Divisor diario validado; semestre completo: 180") }
                    else { campo("base","Sueldo de abril/octubre o al cese") }
                    campo("familiar","Asignación familiar computable")
                    campo("fijos","Otros conceptos fijos computables")
                    Picker("Gratificación", selection: $modoGrati) {
                        Text("Estimada").tag("Estimada"); Text("Percibida").tag("Percibida"); Text("Histórica").tag("Histórica")
                    }
                    if modoGrati == "Percibida" {
                        campo("gratificacion", "Última gratificación pagada, sin bono extraordinario")
                    } else {
                        if modoGrati == "Histórica" {
                            Campo(nombre:"RC histórica de junio / noviembre", texto:$rcGrati)
                            Toggle("Coincide con lo percibido", isOn:$gratiConfirmada)
                        } else {
                            Campo(nombre:"Asignación familiar histórica", texto:$familiarHistorica)
                            Campo(nombre:"Otros fijos históricos", texto:$fijosHistoricos)
                            Aviso(texto:"Estimación con sueldo constante. Cambiar el sueldo actualiza esta gratificación. Si hubo aumentos o variables, usa Percibida o Histórica.")
                        }
                        Campo(nombre:"Meses calendario completos de gratificación (0–6)", texto:$mesesGrati)
                        Campo(nombre:"Días NO computables de gratificación", texto:$faltasGrati)
                        Aviso(texto:"Julio: enero–junio; diciembre: julio–diciembre. Son períodos distintos de CTS. No incluir bono extraordinario.")
                    }
                    switch Result(catching: gratificacionActual) {
                    case .success(let importe): LabeledContent("Gratificación usada", value: Entrada.soles(importe))
                    case .failure(let error): Text(error.localizedDescription).foregroundStyle(.red)
                    }
                    campo("semestrales","Otros conceptos semestrales percibidos")
                    campo("anuales","Conceptos anuales percibidos en el semestre")
                }
                Section("Un concepto complementario variable") {
                    ForEach(0..<6, id: \.self) { i in Campo(nombre: "Mes \(i+1) del semestre", texto: $variables[i]) }
                    Aviso(texto: "Usa un mismo concepto, por ejemplo horas extra. Cero si no se percibió. Se incluye si aparece en tres meses o más; no mezcles conceptos para alcanzar regularidad.")
                }
                if regimen == .pequena { Section("Tope acumulado") { campo("tope","Remuneraciones diarias disponibles (0–90)"); Aviso(texto: "Requiere historial validado; no es el saldo de la cuenta bancaria. Revalúa si hubo cambios de remuneración o régimen.") } }
            }
        }.navigationTitle("CTS Perú")
    }
}
#Preview { NavigationStack { CTSView() } }
