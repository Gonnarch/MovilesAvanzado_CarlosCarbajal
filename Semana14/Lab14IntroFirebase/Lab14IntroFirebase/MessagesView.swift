//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Created by Carlos Carbajal on 25/11/26.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""
    @FocusState private var inputFocused: Bool

    private var currentEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    private var canSend: Bool {
        !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                messagesList
                inputBar
            }
        }
        .onAppear {
            databaseService.startListening()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            AvatarView(email: currentEmail, size: 42)

            VStack(alignment: .leading, spacing: 2) {
                Text("Messages")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(currentEmail)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                try? Auth.auth().signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .buttonStyle(SignOutButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)
        }
    }

    // MARK: - Messages list
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14) {
                    if databaseService.messages.isEmpty {
                        emptyState
                    }

                    ForEach(databaseService.messages) { message in
                        MessageBubble(message: message,
                                      isMine: message.userEmail == currentEmail)
                            .id(message.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .animation(.spring(response: 0.4, dampingFraction: 0.8),
                           value: databaseService.messages.count)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: databaseService.messages.count) {
                if let last = databaseService.messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 54))
                .foregroundStyle(Theme.gradient)
            Text("Aún no hay mensajes")
                .font(.headline)
                .foregroundColor(.white)
            Text("¡Sé el primero en escribir!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.top, 120)
    }

    // MARK: - New message input
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("", text: $newMessage,
                      prompt: Text("Type a message...").foregroundColor(.white.opacity(0.4)),
                      axis: .vertical)
                .lineLimit(1...4)
                .foregroundColor(.white)
                .tint(Theme.orange)
                .focused($inputFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.08),
                            in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(inputFocused ? Theme.orange.opacity(0.8) : Color.white.opacity(0.12),
                                lineWidth: 1)
                )

            Button(action: send) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 46, height: 46)
                    .background(canSend ? AnyShapeStyle(Theme.gradient)
                                        : AnyShapeStyle(Color.white.opacity(0.12)),
                                in: Circle())
                    .shadow(color: canSend ? Theme.orange.opacity(0.5) : .clear, radius: 10)
                    .scaleEffect(canSend ? 1.0 : 0.9)
            }
            .disabled(!canSend)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    private func send() {
        let text = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        databaseService.addMessage(text: text)
        newMessage = ""
    }
}

// MARK: - Burbuja de mensaje
struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isMine {
                Spacer(minLength: 50)
            } else {
                AvatarView(email: message.userEmail, size: 30)
            }

            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                if !isMine {
                    Text(message.userEmail)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(AvatarView.color(for: message.userEmail))
                }

                Text(message.text)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(bubbleBackground)
                    .clipShape(bubbleShape)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.4))
            }

            if !isMine {
                Spacer(minLength: 50)
            }
        }
    }

    private var bubbleShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(topLeadingRadius: 18,
                               bottomLeadingRadius: isMine ? 18 : 4,
                               bottomTrailingRadius: isMine ? 4 : 18,
                               topTrailingRadius: 18,
                               style: .continuous)
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        if isMine {
            Theme.gradient
        } else {
            Color.white.opacity(0.1)
        }
    }
}

#Preview {
    MessagesView()
}
