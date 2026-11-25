//
//  ContentView.swift
//  Semana13_MetodosAPI
//
//  Created by Carlos Daniel Carbajal Durand
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                FondoApp()

                VStack(spacing: 14) {
                    ResumenCard(total: viewModel.users.count,
                                mostrando: viewModel.filteredUsers.count)

                    BuscadorView(texto: $viewModel.searchText)

                    if viewModel.filteredUsers.isEmpty {
                        Spacer()
                        if viewModel.users.isEmpty && viewModel.searchText.isEmpty {
                            ProgressView("Cargando usuarios...").tint(.indigo)
                        } else {
                            SinResultadosView(busqueda: viewModel.searchText)
                        }
                        Spacer()
                    } else {
                        List(viewModel.filteredUsers) { user in
                            UserRow(user: user)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteUser(id: user.id)
                                        }
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }

                                    Button {
                                        editingUser = user
                                        showingForm = true
                                    } label: {
                                        Label("Editar", systemImage: "pencil")
                                    }.tint(.blue)
                                }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .padding(.bottom, 70)
                        .refreshable {
                            await viewModel.fetchUsers()
                        }
                    }
                }
                .padding(.horizontal)

                // Botón flotante para agregar
                Button {
                    editingUser = nil
                    showingForm = true
                } label: {
                    Label("Agregar Usuario", systemImage: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: .indigo.opacity(0.4), radius: 10, y: 5)
                }
                .padding()
            }
            .navigationTitle("Usuarios")
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
            // Lee editingUser en el body para que el sheet reciba el usuario actualizado
            // (sin esto SwiftUI puede abrir "Nuevo Usuario" al tocar Editar)
            .onChange(of: editingUser?.id) { _, _ in }
            .sheet(isPresented: $showingForm) {
                if let user = editingUser {
                    UserFormView(name: user.name, email: user.email, isEditing: true) { name, email in
                        let updated = User(id: user.id, name: name, email: email)
                        Task {
                            await viewModel.updateUser(user: updated)
                        }
                    }
                } else {
                    UserFormView(name: "", email: "", isEditing: false) { name, email in
                        Task {
                            await viewModel.createUser(name: name, email: email)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Componentes de diseño

private struct FondoApp: View {
    var body: some View {
        LinearGradient(colors: [Color.indigo.opacity(0.18), Color.purple.opacity(0.08), Color(.systemBackground)],
                       startPoint: .topLeading, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

private struct ResumenCard: View {
    let total: Int
    let mostrando: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("async / await · URLSession")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                Text("\(total) usuarios")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text(mostrando == total ? "Desliza una fila para editar o eliminar" : "Mostrando \(mostrando) de \(total)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.85))
            }
            Spacer()
            Image(systemName: "person.3.fill")
                .font(.system(size: 34))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .background(
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .indigo.opacity(0.35), radius: 10, y: 6)
    }
}

private struct BuscadorView: View {
    @Binding var texto: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.indigo)
            TextField("Buscar usuario por nombre", text: $texto)
                .autocorrectionDisabled()
            if !texto.isEmpty {
                Button {
                    texto = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.indigo.opacity(0.25), lineWidth: 1)
        )
    }
}

private struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(nombre: user.name, id: user.id)
            VStack(alignment: .leading, spacing: 3) {
                Text(user.name)
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: "envelope")
                        .font(.caption2)
                    Text(user.email)
                        .font(.subheadline)
                }
                .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.left.2")
                .font(.caption.bold())
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

private struct AvatarView: View {
    let nombre: String
    let id: Int

    private let colores: [Color] = [.indigo, .pink, .orange, .teal, .purple, .blue, .green, .red, .mint, .cyan]

    private var iniciales: String {
        nombre.split(separator: " ")
            .filter { !$0.hasSuffix(".") }
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
    }

    var body: some View {
        let color = colores[abs(id) % colores.count]
        Text(iniciales)
            .font(.subheadline.bold())
            .foregroundColor(.white)
            .frame(width: 46, height: 46)
            .background(
                LinearGradient(colors: [color, color.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(Circle())
    }
}

private struct SinResultadosView: View {
    let busqueda: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.indigo.opacity(0.7))
            Text("Sin resultados")
                .font(.headline)
            Text(busqueda.isEmpty ? "No hay usuarios registrados" : "No hay usuarios que coincidan con \"\(busqueda)\"")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
