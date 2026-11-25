//
//  Theme.swift
//  Lab14IntroFirebase
//
//  Created by Carlos Carbajal on 25/11/26.
//

import SwiftUI

// MARK: - Colores de la app
enum Theme {
    static let orange = Color(red: 1.00, green: 0.55, blue: 0.00)
    static let amber  = Color(red: 1.00, green: 0.78, blue: 0.20)
    static let pink   = Color(red: 1.00, green: 0.30, blue: 0.45)
    static let bgTop    = Color(red: 0.07, green: 0.07, blue: 0.16)
    static let bgBottom = Color(red: 0.16, green: 0.06, blue: 0.22)

    static var gradient: LinearGradient {
        LinearGradient(colors: [pink, orange, amber],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
}

// MARK: - Fondo animado con "blobs" difuminados
struct AnimatedBackground: View {
    @State private var move = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom],
                           startPoint: .top, endPoint: .bottom)

            Circle()
                .fill(Theme.orange.opacity(0.45))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: move ? -120 : 100, y: move ? -260 : -180)

            Circle()
                .fill(Theme.pink.opacity(0.35))
                .frame(width: 280, height: 280)
                .blur(radius: 90)
                .offset(x: move ? 140 : -60, y: move ? 280 : 200)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                move.toggle()
            }
        }
    }
}

// MARK: - Contenedor de campo de texto con icono
struct FieldContainer<Content: View>: View {
    let icon: String
    var isFocused: Bool
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isFocused ? Theme.orange : .white.opacity(0.5))
                .frame(width: 22)
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isFocused ? Theme.orange : Color.white.opacity(0.12),
                        lineWidth: isFocused ? 1.5 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Avatar con la inicial del email
struct AvatarView: View {
    let email: String
    var size: CGFloat = 36

    static let palette: [Color] = [.orange, .pink, .purple, .blue, .teal, .green, .indigo]

    static func color(for email: String) -> Color {
        let sum = email.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return palette[sum % palette.count]
    }

    var body: some View {
        let base = Self.color(for: email)
        Text(String(email.prefix(1)).uppercased())
            .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(
                LinearGradient(colors: [base, base.opacity(0.6)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(Circle())
    }
}
