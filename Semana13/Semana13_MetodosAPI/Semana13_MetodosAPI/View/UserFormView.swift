//
//  UserFormView.swift
//  Semana13_MetodosAPI
//
//  Created by Carlos Daniel Carbajal Durand
//

import SwiftUI

struct UserFormView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var name: String
    @State var email: String
    var isEditing: Bool
    var onSubmit: (String, String) -> Void

    private var formularioValido: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && email.contains("@")
    }

    private var iniciales: String {
        let partes = name.split(separator: " ").prefix(2).compactMap { $0.first }.map { String($0) }
        return partes.isEmpty ? "?" : partes.joined().uppercased()
    }

    var body: some View {
        NavigationView {
            Form {
                // Vista previa del avatar
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text(iniciales)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(width: 84, height: 84)
                                .background(
                                    LinearGradient(colors: [.indigo, .purple],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(Circle())
                                .shadow(color: .indigo.opacity(0.4), radius: 8, y: 4)
                            Text(isEditing ? "Modifica los datos" : "Completa los datos")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.clear)

                Section(header: Text("Datos del usuario")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 24)
                        TextField("Nombre", text: $name)
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }

                Section {
                    Button {
                        onSubmit(name, email)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label(isEditing ? "Actualizar usuario" : "Guardar usuario",
                                  systemImage: isEditing ? "checkmark.circle.fill" : "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .disabled(!formularioValido)
                    .listRowBackground(
                        LinearGradient(colors: formularioValido ? [.indigo, .purple] : [.gray.opacity(0.5), .gray.opacity(0.4)],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                }
            }
            .navigationTitle(isEditing ? "Editar Usuario" : "Nuevo Usuario")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    onSubmit(name, email)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!formularioValido)
            )
        }
        .tint(.indigo)
    }
}
