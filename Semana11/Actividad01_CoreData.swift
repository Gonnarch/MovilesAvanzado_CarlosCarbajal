// LAB 11 - Actividad 01: UIKit + Core Data. iOS 17 o posterior.
// Un archivo por actividad, solicitado para la entrega.
// Proyecto separado: iOS App / SwiftUI / Storage None. Quita del target
// el archivo App y ContentView de la plantilla y agrega ESTE archivo.
// El arranque UIKit y el modelo se definen aquí para no depender de
// Storyboard, AppDelegate externo ni archivos .xcdatamodeld adicionales.
import UIKit
import CoreData

// MARK: - Modelo Contacto y Grupo (pasos 2 y 12)
@objc(Contacto)
final class Contacto: NSManagedObject {
    @NSManaged var nombre: String?
    @NSManaged var telefono: String?
    @NSManaged var direccion: String?
    @NSManaged var grupo: Grupo?
}

@objc(Grupo)
final class Grupo: NSManagedObject {
    @NSManaged var nombre: String?
    @NSManaged var contactos: Set<Contacto>?
}

@MainActor
final class Persistencia {
    static let shared = Persistencia()
    let container: NSPersistentContainer

    private init() {
        let modelo = NSManagedObjectModel()
        let contacto = NSEntityDescription()
        contacto.name = "Contacto"
        contacto.managedObjectClassName = NSStringFromClass(Contacto.self)
        let grupo = NSEntityDescription()
        grupo.name = "Grupo"
        grupo.managedObjectClassName = NSStringFromClass(Grupo.self)
        func texto(_ nombre: String) -> NSAttributeDescription {
            let atributo = NSAttributeDescription()
            atributo.name = nombre
            atributo.attributeType = .stringAttributeType
            atributo.isOptional = true
            return atributo
        }
        let pertenece = NSRelationshipDescription()
        pertenece.name = "grupo"
        pertenece.destinationEntity = grupo
        pertenece.minCount = 0
        pertenece.maxCount = 1
        pertenece.isOptional = true
        pertenece.deleteRule = .nullifyDeleteRule
        let miembros = NSRelationshipDescription()
        miembros.name = "contactos"
        miembros.destinationEntity = contacto
        miembros.minCount = 0
        miembros.maxCount = 0 // Cero significa sin límite: relación To Many.
        miembros.isOptional = true
        miembros.deleteRule = .nullifyDeleteRule
        pertenece.inverseRelationship = miembros
        miembros.inverseRelationship = pertenece
        contacto.properties = [texto("nombre"), texto("telefono"),
                               texto("direccion"), pertenece]
        grupo.properties = [texto("nombre"), miembros]
        modelo.entities = [contacto, grupo]
        container = NSPersistentContainer(
            name: "apple_lab11_01_UIKit_CoreData", managedObjectModel: modelo)
        container.loadPersistentStores { _, error in
            if let error { fatalError("No se pudo abrir Core Data: \(error)") }
        }
    }
}

// MARK: - Inicio UIKit sin storyboard
@main
@MainActor
final class ContactosAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let ventana = UIWindow(frame: UIScreen.main.bounds)
        ventana.rootViewController = UINavigationController(
            rootViewController: ViewController())
        ventana.makeKeyAndVisible()
        window = ventana
        return true
    }
}

// MARK: - Pantalla principal y conexión (pasos 4 y 5)
final class ViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate, UISearchResultsUpdating {
    let TablaContacto = UITableView(frame: .zero, style: .insetGrouped)
    var contactos: [Contacto] = []
    private let buscador = UISearchController(searchResultsController: nil)
    private var soloAmigos = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista de Contactos - Tecsup"
        view.backgroundColor = .systemBackground
        TablaContacto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(TablaContacto)
        NSLayoutConstraint.activate([
            TablaContacto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            TablaContacto.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            TablaContacto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            TablaContacto.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self,
                            action: #selector(agregarContacto(_:))),
            UIBarButtonItem(image: UIImage(systemName: "person.3"), style: .plain,
                            target: self, action: #selector(asignarGrupo)),
            UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                            style: .plain, target: self, action: #selector(alternarGrupo))
        ]
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre"
        navigationItem.searchController = buscador
        definesPresentationContext = true
        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()
    }

    func conexion() -> NSManagedObjectContext {
        Persistencia.shared.container.viewContext
    }
    func mostrarRutaBaseDeDatos() {
        let ruta = Persistencia.shared.container.persistentStoreCoordinator
            .persistentStores.first?.url?.path ?? "sin ruta"
        print("Base de datos SQLite en: \(ruta)")
    }
    private func informar(_ mensaje: String) {
        let alerta = UIAlertController(title: "Contactos", message: mensaje,
                                      preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    // MARK: - READ ordenado (paso 6)
    func cargarInfoCoreData() {
        let request = NSFetchRequest<Contacto>(entityName: "Contacto")
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        var filtros: [NSPredicate] = []
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        if soloAmigos { filtros.append(NSPredicate(format: "grupo.nombre == %@", "Amigos")) }
        if !filtros.isEmpty { request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros) }
        do {
            contactos = try conexion().fetch(request)
            TablaContacto.reloadData() // UIKit necesita refrescar la tabla.
        } catch { informar("Error al leer: \(error.localizedDescription)") }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let contacto = contactos[indexPath.row]
        celda.textLabel?.text = contacto.nombre
        celda.detailTextLabel?.text = "\(contacto.telefono ?? "") | \(contacto.direccion ?? "") | \(contacto.grupo?.nombre ?? "Sin grupo")"
        celda.detailTextLabel?.numberOfLines = 0
        celda.accessoryType = .disclosureIndicator
        return celda
    }

    // MARK: - CREATE y UPDATE (pasos 7 y 9)
    @objc func agregarContacto(_ sender: UIBarButtonItem) { formulario(contacto: nil) }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        formulario(contacto: contactos[indexPath.row])
    }
    private func formulario(contacto: Contacto?) {
        let alerta = UIAlertController(title: contacto == nil ? "Agregar Contacto" : "Editar Contacto",
                                      message: "Nombre, teléfono y dirección", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = contacto?.nombre }
        alerta.addTextField {
            $0.placeholder = "Teléfono"; $0.text = contacto?.telefono; $0.keyboardType = .phonePad
        }
        alerta.addTextField { $0.placeholder = "Dirección"; $0.text = contacto?.direccion }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self else { return }
            let nombre = (alerta.textFields?[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !nombre.isEmpty else { self.informar("Escribe un nombre."); return }
            let contexto = self.conexion()
            let objeto = contacto ?? (NSEntityDescription.insertNewObject(
                forEntityName: "Contacto", into: contexto) as! Contacto)
            objeto.nombre = nombre
            objeto.telefono = alerta.textFields?[1].text ?? ""
            objeto.direccion = alerta.textFields?[2].text ?? ""
            do {
                try contexto.save() // Inserción y cambios pasan del contexto al SQLite.
                self.cargarInfoCoreData()
            } catch {
                contexto.rollback()
                self.informar("No se pudo guardar: \(error.localizedDescription)")
            }
        })
        present(alerta, animated: true)
    }

    // MARK: - DELETE con swipe (paso 10)
    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        contexto.delete(contactos[indexPath.row])
        do {
            try contexto.save()
            contactos.remove(at: indexPath.row)
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            contexto.rollback()
            informar("No se pudo eliminar: \(error.localizedDescription)")
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { eliminarContacto(at: indexPath) }
    }

    // MARK: - Filtro y relación (pasos 11 y 12)
    func buscarContactos(texto: String) throws -> [Contacto] {
        let request = NSFetchRequest<Contacto>(entityName: "Contacto")
        request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@", texto)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return try conexion().fetch(request)
    }
    func contactosDelGrupo(_ nombreGrupo: String) throws -> [Contacto] {
        let request = NSFetchRequest<Contacto>(entityName: "Contacto")
        request.predicate = NSPredicate(format: "grupo.nombre == %@", nombreGrupo)
        return try conexion().fetch(request)
    }
    func updateSearchResults(for searchController: UISearchController) { cargarInfoCoreData() }
    @objc private func alternarGrupo() {
        soloAmigos.toggle()
        navigationItem.prompt = soloAmigos ? "Filtro: Amigos" : nil
        cargarInfoCoreData()
    }
    @objc private func asignarGrupo() { probarRelacion() }
    func probarRelacion() {
        guard let primero = contactos.first else { informar("Agrega un contacto primero."); return }
        let contexto = conexion()
        let request = NSFetchRequest<Grupo>(entityName: "Grupo")
        request.predicate = NSPredicate(format: "nombre == %@", "Amigos")
        request.fetchLimit = 1
        do {
            // Reutilizar el grupo permite repetir la demostración sin duplicarlo.
            let grupo = try contexto.fetch(request).first
                ?? (NSEntityDescription.insertNewObject(forEntityName: "Grupo", into: contexto) as! Grupo)
            grupo.nombre = "Amigos"
            primero.grupo = grupo // Core Data mantiene el inverso contactos.
            try contexto.save()
            print("El grupo Amigos tiene \(grupo.contactos?.count ?? 0) contacto(s)")
            cargarInfoCoreData()
        } catch {
            contexto.rollback()
            informar("Error en la relación: \(error.localizedDescription)")
        }
    }
}
