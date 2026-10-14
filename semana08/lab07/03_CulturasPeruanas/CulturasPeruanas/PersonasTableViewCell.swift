import UIKit
final class PersonasTableViewCell: UITableViewCell {
    @IBOutlet weak var PersonaImagen: UIImageView!
    @IBOutlet weak var personaNombre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        PersonaImagen.layer.cornerRadius = 12
        PersonaImagen.clipsToBounds = true
        personaNombre.adjustsFontForContentSizeCategory = true
    }
}
