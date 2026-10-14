import UIKit
final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    private let nombres = ["Jaime Gómez", "Juan León", "Silvia Montoya", "Theo Díaz", "Elliot Gamarra"]
    override func viewDidLoad() { super.viewDidLoad(); title = "Personas"; tableView.rowHeight = 80 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { nombres.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PersonasTableViewCell
        cell.personaNombre.text = nombres[indexPath.row]
        cell.PersonaImagen.image = UIImage(named: "avatar\(indexPath.row + 1)")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Persona seleccionada", message: "Seleccionaste a \(nombres[indexPath.row]).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
