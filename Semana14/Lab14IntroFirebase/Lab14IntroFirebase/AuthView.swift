//
//  AuthView.swift
//  Lab14IntroFirebase
//
//  Created by Carlos Carbajal on 25/11/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var pulse = false
    @State private var authStateListener: AuthStateDidChangeListenerHandle?
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        ZStack {
            if isSignedIn {
                // Show MessagesView when signed in
                MessagesView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                loginScreen
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: isSignedIn)
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onDisappear {
            if let handle = authStateListener {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
        .onChange(of: isSignedIn) {
            // Clear form when signing out
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // MARK: - Pantalla de login
    private var loginScreen: some View {
        ZStack {
            AnimatedBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    header
                    formCard
                    footer
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.gradient)
                    .frame(width: 96, height: 96)
                    .shadow(color: Theme.orange.opacity(0.6), radius: 24)
                    .scaleEffect(pulse ? 1.05 : 0.95)

                Image(systemName: "flame.fill")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.white)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }

            Text("Lab 14: Firebase")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundColor(.white)

            Text("Autenticación y mensajes en tiempo real")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
        }
    }

    private var formCard: some View {
        VStack(spacing: 16) {
            FieldContainer(icon: "envelope.fill", isFocused: focusedField == .email) {
                TextField("", text: $email,
                          prompt: Text("Email").foregroundColor(.white.opacity(0.4)))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            }

            FieldContainer(icon: "lock.fill", isFocused: focusedField == .password) {
                Group {
                    if showPassword {
                        TextField("", text: $password,
                                  prompt: Text("Password").foregroundColor(.white.opacity(0.4)))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("", text: $password,
                                    prompt: Text("Password").foregroundColor(.white.opacity(0.4)))
                    }
                }
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { signIn() }

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Button {
                signIn()
            } label: {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Sign In")
                        Image(systemName: "arrow.right")
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isLoading)

            HStack {
                Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                Text("o").font(.caption).foregroundColor(.white.opacity(0.5))
                Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
            }

            Button {
                signUp()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                    Text("Sign Up")
                }
            }
            .buttonStyle(SecondaryButtonStyle())
            .disabled(isLoading)
        }
        .foregroundColor(.white)
        .tint(Theme.orange)
        .padding(24)
        .background(.ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    private var footer: some View {
        Text("Carlos Carbajal · Tecsup C24-A")
            .font(.footnote)
            .foregroundColor(.white.opacity(0.4))
    }

    // MARK: - Authentication Functions
    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign in failed: \(error.localizedDescription)"
                showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                isSignedIn = true
                alertMessage = "Sign in successful!"
                showAlert = true
            }
        }
    }

    func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    func checkAuthState() {
        // Listen for authentication state changes and store the listener handle
        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Theme.orange.opacity(0.5),
                    radius: configuration.isPressed ? 4 : 14,
                    y: configuration.isPressed ? 2 : 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white.opacity(configuration.isPressed ? 0.12 : 0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.gradient, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.red)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(Color.red.opacity(configuration.isPressed ? 0.3 : 0.18), in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
    }
}

#Preview {
    AuthView()
        .preferredColorScheme(.dark)
}
