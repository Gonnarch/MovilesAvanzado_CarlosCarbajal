import UIKit
final class Profesor: NSObject {
    let nombre: String
    let cargo: String
    let foto: UIImage
    init(nombre: String, cargo: String, foto: UIImage) {
        self.nombre = nombre; self.cargo = cargo; self.foto = foto
        super.init()
    }
    static let ejemplos: [Profesor] = [
        Profesor(nombre: "Jaime Gómez", cargo: "Coordinador de Software", foto: UIImage(named: "avatar1")!),
        Profesor(nombre: "Jaime Farfán", cargo: "Docente de Software TC", foto: UIImage(named: "avatar2")!),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "avatar3")!),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")!),
        Profesor(nombre: "Theobaldo Díaz", cargo: "Docente de Software TC", foto: UIImage(named: "avatar5")!),
        Profesor(nombre: "Elliot Gamarra", cargo: "Docente de Software TC", foto: UIImage(named: "avatar6")!),
        Profesor(nombre: "Edwin Huerta", cargo: "Docente de Redes TC", foto: UIImage(named: "avatar7")!)
    ]
}
