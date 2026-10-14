import UIKit
final class DetalleCulturaViewController: UIViewController {
    private let cultura: Cultura
    init(cultura: Cultura) { self.cultura = cultura; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("Usar init(cultura:)") }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura.nombre
        view.backgroundColor = .systemBackground
        let scroll = UIScrollView()
        let stack = UIStackView()
        stack.axis = .vertical; stack.spacing = 20
        let imagen = UIImageView(image: UIImage(named: cultura.imagen))
        imagen.contentMode = .scaleAspectFit
        imagen.accessibilityLabel = "Ilustración representativa de la cultura \(cultura.nombre)"
        imagen.isAccessibilityElement = true
        imagen.heightAnchor.constraint(equalToConstant: 240).isActive = true
        stack.addArrangedSubview(imagen)
        for (texto, estilo) in [(cultura.nombre, UIFont.TextStyle.largeTitle), ("Región: \(cultura.region)", .headline), (cultura.descripcion, .body)] {
            let label = UILabel(); label.text = texto; label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: estilo); label.adjustsFontForContentSizeCategory = true
            stack.addArrangedSubview(label)
        }
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
}
