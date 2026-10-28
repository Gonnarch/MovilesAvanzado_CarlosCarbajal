# Pruebas de modelos Swift

Estas pruebas se entregan preparadas, pero no se ejecutaron aquí: no hay compilador Swift/Xcode disponible. Los modelos se extrajeron del mismo código de las apps, sin las vistas.

En una Mac con herramientas de Xcode, abre Terminal en esta carpeta y ejecuta:

```sh
swiftc Modelos.swift main.swift -o pruebas_s08
./pruebas_s08
```

Esto verifica el motor de cálculo. No sustituye compilar y recorrer las interfaces de los ocho proyectos en el simulador. Al modificar un modelo en su app, actualiza esta copia antes de repetir las pruebas.
