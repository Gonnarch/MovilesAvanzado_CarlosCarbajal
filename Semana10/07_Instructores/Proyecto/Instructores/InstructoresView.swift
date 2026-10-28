import SwiftUI
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
struct InstructoresView: View {
    @State private var horas = "23", uit = "5500", mes = "1"
    @State private var onp = true
    @State private var prima = "1.37", comision = "0", topeSeguro = "12732.70"
    @State private var previos = "0", gratificaciones = "9200", bonificaciones = "828", retenido = "0", extra = "0"
    var body: some View {
        Form {
            Section("Contrato del ejercicio") {
                Campo(nombre:"Horas semanales (0–23)",texto:$horas)
                Text("S/ 50 por hora × 4 semanas, según la guía")
                Toggle("Sistema ONP (13%)", isOn:$onp)
                if !onp {
                    Campo(nombre:"Prima de seguro AFP (%)",texto:$prima)
                    Campo(nombre:"Comisión sobre flujo (%) · saldo: 0",texto:$comision)
                    Campo(nombre:"Tope de remuneración asegurable SBS",texto:$topeSeguro)
                    Aviso(texto:"Valores AFP editables. Verifica mes y AFP en SBS. La comisión sobre saldo no se descuenta otra vez del sueldo.")
                }
            }
            Section("Proyección de quinta categoría") {
                Campo(nombre:"Mes (1–12)",texto:$mes); Campo(nombre:"UIT del año",texto:$uit)
                Campo(nombre:"Ingresos previos gravados, sin gratificaciones duplicadas",texto:$previos)
                Campo(nombre:"Gratificaciones ordinarias de todo el año",texto:$gratificaciones)
                Campo(nombre:"Bonificaciones y otros ingresos anuales no duplicados",texto:$bonificaciones)
                Campo(nombre:"Retenciones del tramo que corresponde al mes",texto:$retenido)
                Campo(nombre:"Ingreso extraordinario del mes actual",texto:$extra)
                Aviso(texto:"Ene–mar: no restar; abril: enero–marzo; mayo–julio: enero–abril; agosto: enero–julio; set–nov: enero–agosto; diciembre: enero–noviembre. No deducir AFP/ONP ni 3 UIT en la retención del empleador.")
            }
            Section("Resultado") {
                switch Result(catching: calcular) {
                case .success(let filas): ForEach(filas, id: \.0) { fila in LabeledContent(fila.0, value: Entrada.soles(fila.1)) }
                case .failure(let error): Text(error.localizedDescription).foregroundStyle(.red)
                }
                Aviso(texto:"Caso dependiente domiciliado. El bruto mantiene las 4 semanas académicas. La proyección supone salario estable en meses restantes. No sustituye una planilla con múltiples empleadores, subsidios, cese o remuneración variable.")
            }
        }.navigationTitle("Pago de instructores")
    }
    private func calcular() throws -> [(String,Double)] {
        let h = try Entrada.numero(horas,"Horas",max:23)
        let u = try Entrada.numero(uit,"UIT",min:1)
        let m = try Entrada.entero(mes,"Mes",min:1,max:12)
        let bruto = h * 50 * 4
        let renta = try Entrada.numero(previos,"Ingresos previos") + bruto * Double(13-m) + Entrada.numero(gratificaciones,"Gratificaciones") + Entrada.numero(bonificaciones,"Bonificaciones")
        let r = try Entrada.numero(retenido,"Retenciones")
        let e = try Entrada.numero(extra,"Extraordinario")
        let pension: Double
        if onp { pension = Entrada.dinero(bruto * 0.13) }
        else {
            let p = try Entrada.numero(prima,"Prima",max:100)/100
            let c = try Entrada.numero(comision,"Comisión",max:100)/100
            let t = try Entrada.numero(topeSeguro,"Tope",min:1)
            pension = Entrada.dinero(bruto * (0.10+c) + min(bruto,t)*p)
        }
        let ir = PagoModelo.retencion(ingreso:renta,uit:u,mes:m,retenido:r,extraordinario:e)
        // Pago extraordinario se presenta aparte. Su afectación pensionaria necesita clasificación.
        let neto = Entrada.dinero(bruto - pension - ir)
        return [("Bruto mensual ordinario",bruto),("AFP / ONP del bruto ordinario",pension),("Renta anual proyectada",renta+e),("IR del mes",ir),("Neto ordinario después del IR",neto),("EsSalud guía: empleador 9%",Entrada.dinero(bruto*0.09))]
    }
}
#Preview { NavigationStack { InstructoresView() } }
