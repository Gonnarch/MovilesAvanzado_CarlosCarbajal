import UIKit
final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    private let profesores = Profesor.ejemplos
    override func viewDidLoad() { super.viewDidLoad(); title = "Profesores de Tecsup"; tableView.rowHeight = 80 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { profesores.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let profesor = profesores[indexPath.row]
        cell.textLabel?.text = profesor.nombre
        cell.detailTextLabel?.text = profesor.cargo
        cell.imageView?.image = profesor.foto
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
}
