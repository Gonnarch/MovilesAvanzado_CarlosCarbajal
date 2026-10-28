# Contenedores

Abre `Proyecto/Contenedores.xcodeproj` en Xcode 15 o posterior, en una Mac. Selecciona el esquema Contenedores y un simulador iPhone o iPad con iOS 17 o posterior. Pulsa Run. Para un dispositivo físico, selecciona tu equipo de firma en Signing & Capabilities.

El proyecto incluye todos sus archivos y no requiere paquetes externos. Cada carpeta es independiente. No arrastres varios archivos `App.swift` a un mismo target: cada aplicación tiene un único punto de entrada `@main`.

La vista inicial es `Ventana02`. Los cálculos se actualizan al editar para no mostrar resultados antiguos. Puedes abrir su `#Preview` en el Canvas.

Verificación pendiente en Mac: compilación de SwiftUI, ejecución en simulador, accesibilidad con VoiceOver y captura de pantallas reales. En Windows se revisaron estructura y lógica por casos de referencia, no se ejecutó Xcode.
