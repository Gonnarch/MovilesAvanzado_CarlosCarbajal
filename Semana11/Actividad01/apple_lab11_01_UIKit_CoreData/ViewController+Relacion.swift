//
//  ViewController+Relacion.swift
//  apple_lab11_01_UIKit_CoreData
//
//  Created by Tecsup on 4/11/26.
//


import UIKit
import CoreData

extension ViewController {

    // MARK: - Buscar contactos por nombre

    // Busca contactos cuyo nombre contenga el texto indicado
    func buscarContactos(texto: String) -> [Contacto] {

        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()

        // Filtra sin distinguir mayúsculas ni tildes
        request.predicate = NSPredicate(
            format: "nombre CONTAINS[cd] %@",
            texto
        )

        // Ordena los resultados alfabéticamente
        request.sortDescriptors = [
            NSSortDescriptor(key: "nombre", ascending: true)
        ]

        return (try? conexion().fetch(request)) ?? []
    }
    
    // MARK: - Relación Grupo y Contacto

    // Crea un grupo y lo asigna al primer contacto
    func probarRelacion() {

        let contexto = conexion()

        let grupo = NSEntityDescription.insertNewObject(
            forEntityName: "Grupo",
            into: contexto
        ) as! Grupo

        grupo.nombre = "Amigos"

        if let primero = contactos.first {
            primero.grupo = grupo
        }

        do {
            try contexto.save()

            print("El grupo \(grupo.nombre ?? "") tiene \(grupo.contactos?.count ?? 0) contacto(s)")

        } catch {
            print("Error al guardar la relación: \(error)")
        }
    }

    // Busca contactos que pertenecen a un grupo
    func contactosDelGrupo(_ nombreGrupo: String) -> [Contacto] {

        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()

        request.predicate = NSPredicate(
            format: "grupo.nombre == %@",
            nombreGrupo
        )

        return (try? conexion().fetch(request)) ?? []
    }

}
