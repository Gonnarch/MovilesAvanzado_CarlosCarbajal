import Foundation
struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String
    static let todas: [Cultura] = [
        Cultura(nombre: "Caral", region: "Lima, valle de Supe", descripcion: "Una de las civilizaciones más antiguas de América. Destaca por sus centros urbanos, plazas circulares y edificios monumentales. Su desarrollo se vincula con la agricultura, la pesca y el intercambio.", imagen: "caral"),
        Cultura(nombre: "Chavín", region: "Áncash, sierra central", descripcion: "Se desarrolló alrededor del centro ceremonial de Chavín de Huántar. Su arte representa seres con rasgos humanos y animales. El Lanzón y las cabezas clavas son expresiones de su tradición religiosa.", imagen: "chavin"),
        Cultura(nombre: "Paracas", region: "Ica, costa sur", descripcion: "Es reconocida por sus textiles de gran complejidad y sus prácticas funerarias. Sus mantos representan figuras humanas y animales. También se han encontrado evidencias de trepanaciones craneanas.", imagen: "paracas"),
        Cultura(nombre: "Nazca", region: "Ica, costa sur", descripcion: "Destacó por su cerámica policroma y los geoglifos de las pampas de Nazca. Desarrolló sistemas de manejo del agua, como los puquios, para vivir en un entorno árido.", imagen: "nazca"),
        Cultura(nombre: "Moche", region: "La Libertad y Lambayeque, costa norte", descripcion: "Desarrolló centros ceremoniales como las Huacas del Sol y de la Luna. Sus cerámicas y objetos de metal representan actividades cotidianas y ceremoniales. El hallazgo del Señor de Sipán muestra la riqueza de sus élites.", imagen: "moche"),
        Cultura(nombre: "Wari", region: "Ayacucho y otras regiones andinas", descripcion: "Se expandió desde Ayacucho y estableció centros administrativos en diferentes zonas de los Andes. Destacó por su planificación urbana, redes de intercambio y producción textil.", imagen: "wari"),
        Cultura(nombre: "Chimú", region: "La Libertad, costa norte", descripcion: "Tuvo su capital en Chan Chan, una gran ciudad construida principalmente con adobe. Destacó por la orfebrería y por los sistemas de riego que sostuvieron la agricultura en la costa.", imagen: "chimu"),
        Cultura(nombre: "Inca", region: "Cusco y amplias regiones de los Andes", descripcion: "El Tahuantinsuyo articuló un extenso territorio mediante caminos, centros administrativos y diversas formas de organización del trabajo. Destacan la arquitectura de piedra, los andenes y sitios como Machu Picchu.", imagen: "inca")
    ]
}
