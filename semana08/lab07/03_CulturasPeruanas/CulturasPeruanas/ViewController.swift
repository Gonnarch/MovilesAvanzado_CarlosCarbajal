import UIKit
final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    private let culturas = Cultura.todas
    override func viewDidLoad() { super.viewDidLoad(); title = "Culturas peruanas"; tableView.rowHeight = 88 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { culturas.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PersonasTableViewCell
        let cultura = culturas[indexPath.row]
        cell.personaNombre.text = cultura.nombre
        cell.PersonaImagen.image = UIImage(named: cultura.imagen)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetalleCulturaViewController(cultura: culturas[indexPath.row]), animated: true)
    }
}
