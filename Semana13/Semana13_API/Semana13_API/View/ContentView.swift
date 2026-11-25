//
//  ContentView.swift
//  Semana13_API
//
//  Created by Carlos Daniel Carbajal Durand
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                FondoApp()

                VStack(spacing: 14) {
                    // Tarjeta resumen
                    ResumenCard(total: viewModel.users.count,
                                mostrando: viewModel.filteredUsers.count)

                    // Campo de búsqueda
                    BuscadorView(texto: $viewModel.searchText)

                    // Lista de usuarios filtrados
                    if viewModel.users.isEmpty {
                        Spacer()
                        ProgressView("Cargando usuarios...")
                            .tint(.indigo)
                        Spacer()
                    } else if viewModel.filteredUsers.isEmpty {
                        Spacer()
                        SinResultadosView(busqueda: viewModel.searchText)
                        Spacer()
                    } else {
                        List(viewModel.filteredUsers) { user in
                            UserRow(user: user)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .animation(.easeInOut, value: viewModel.searchText)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Usuarios")
            .onAppear {
                // Llama a la función fetchUsers() del ViewModel que se encarga de realizar la petición a la API
                viewModel.fetchUsers()
            }
        }
    }
}

// MARK: - Componentes de diseño

/// Fondo suave con degradado
private struct FondoApp: View {
    var body: some View {
        LinearGradient(colors: [Color.indigo.opacity(0.18), Color.purple.opacity(0.08), Color(.systemBackground)],
                       startPoint: .topLeading, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

/// Tarjeta con degradado que muestra el total de usuarios
private struct ResumenCard: View {
    let total: Int
    let mostrando: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JSONPlaceholder API")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                Text("\(total) usuarios")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text(mostrando == total ? "Mostrando todos" : "Mostrando \(mostrando) de \(total)")
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

/// Buscador con ícono y botón para limpiar
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

/// Fila de usuario en forma de tarjeta con avatar
private struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(nombre: user.name, id: user.id)
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text("ID #\(user.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

/// Avatar circular con iniciales y color según el id
private struct AvatarView: View {
    let nombre: String
    let id: Int

    private let colores: [Color] = [.indigo, .pink, .orange, .teal, .purple, .blue, .green, .red, .mint, .cyan]

    private var iniciales: String {
        nombre.split(separator: " ")
            .filter { !$0.hasSuffix(".") }   // omite "Mrs."
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

/// Estado vacío cuando el filtro no encuentra coincidencias
private struct SinResultadosView: View {
    let busqueda: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.indigo.opacity(0.7))
            Text("Sin resultados")
                .font(.headline)
            Text("No hay usuarios que coincidan con \"\(busqueda)\"")
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
