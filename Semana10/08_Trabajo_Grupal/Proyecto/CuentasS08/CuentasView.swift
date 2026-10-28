import SwiftUI
struct CuentasView: View {
    @State private var datos = ["cxcInicial":"80000","cxcFinal":"100000","ventas":"720000","vencidas":"20000","incobrable":"5","cxpInicial":"50000","cxpFinal":"70000","compras":"480000","pasivos":"200000"]
    private let campos = [("cxcInicial","CxC inicial"),("cxcFinal","CxC final / total"),("ventas","Ventas a crédito del año"),("vencidas","CxC vencidas al cierre"),("incobrable","Incobrabilidad estimada (%)"),("cxpInicial","CxP inicial"),("cxpFinal","CxP final / proveedores"),("compras","Compras a crédito del año"),("pasivos","Pasivos totales al cierre")]
    var body: some View {
        Form {
            Section("Datos del caso académico · soles") {
                ForEach(campos,id:\.0) { campo in Campo(nombre:campo.1,texto:Binding(get:{datos[campo.0] ?? ""},set:{datos[campo.0]=$0})) }
            }
            Section("Indicadores · base anual de 360 días") {
                switch Result(catching: calcular) {
                case .success(let filas): ForEach(filas,id:\.0) { fila in LabeledContent(fila.0,value:fila.1) }
                case .failure(let e): Text(e.localizedDescription).foregroundStyle(.red)
                }
                Aviso(texto:"La diferencia de plazos omite inventarios: no es el ciclo completo de conversión de efectivo. La provisión porcentual es el ejercicio académico, no una determinación automática de pérdidas crediticias NIIF.")
            }
        }.navigationTitle("Cuentas por cobrar y pagar")
    }
    private func calcular() throws -> [(String,String)] {
        func n(_ k:String) throws -> Double { try Entrada.numero(datos[k] ?? "",k,max:k == "incobrable" ? 100 : 1e12) }
        let ci=try n("cxcInicial"), cf=try n("cxcFinal"), v=try n("ventas"), ve=try n("vencidas"), p=try n("incobrable")
        let pi=try n("cxpInicial"), pf=try n("cxpFinal"), c=try n("compras"), pas=try n("pasivos")
        guard ve <= cf, pf <= pas else { throw ErrorEntrada.mensaje("Las vencidas no pueden exceder CxC total ni proveedores superar pasivos totales.") }
        let ca=(ci+cf)/2, pa=(pi+pf)/2
        func ratio(_ a:Double,_ b:Double,_ unidad:String) -> String { b == 0 ? "No definido (divisor cero)" : String(format:"%.2f %@",a/b,unidad) }
        return [("CxC promedio",Entrada.soles(ca)),("Edad CxC",ratio(ca*360,v,"días")),("Rotación CxC",ratio(v,ca,"veces")),("Morosidad",ratio(ve*100,cf,"%")),("Provisión estimada",Entrada.soles(cf*p/100)),("CxP promedio",Entrada.soles(pa)),("Edad CxP",ratio(pa*360,c,"días")),("Rotación CxP",ratio(c,pa,"veces")),("Endeudamiento proveedores",ratio(pf*100,pas,"%")),("Diferencia de plazos",v == 0 || c == 0 ? "No definido" : String(format:"%.2f días",ca*360/v-pa*360/c))]
    }
}
#Preview { NavigationStack { CuentasView() } }
