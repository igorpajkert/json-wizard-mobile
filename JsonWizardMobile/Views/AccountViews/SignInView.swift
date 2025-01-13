//
//  SignInView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.authHandler) private var authHandler
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    infoText
                    userCredentials
                    passwordResetButton
                    signInButton
                }
                .navigationTitle("Sign In")
                .toolbar {
                    toolbarDismissButton
                }
                .sheet(item: $errorWrapper) { wrapper in
                    ErrorView(errorWrapper: wrapper)
                }
                .padding()
            }
        }
    }
    
    private var sampleImage: some View {
        Image(.account)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var infoText: some View {
        Group {
            sampleImage
            Text("Sign in to your developer account.")
                .font(.headline)
            Text("If you have trouble accessing your account, please contact: igor.pajkert@ipsoftware.org")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    private var userCredentials: some View {
        Group {
            TextField("Email", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 32).stroke(style: StrokeStyle(lineWidth: 2)))
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 32).stroke(style: StrokeStyle(lineWidth: 2)))
        }
        .textInputAutocapitalization(.never)
        .padding(.horizontal)
    }
    
    // TODO: Password Reset
    private var passwordResetButton: some View {
        Button(action:{}) {
            Text("Forgot your password?")
                .font(.callout)
                .padding(.bottom)
        }
    }
    
    private var signInButton: some View {
        Button(action: signIn) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("Sign In")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .disabled(email.isEmpty || password.isEmpty)
        .padding()
    }
    
    // MARK: Toolbar
    private var toolbarDismissButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Dismiss") { dismiss() }
        }
    }
    
    // MARK: - Intents
    private func signIn() {
        Task {
            do {
                try await authHandler.signIn(with: email, password: password)
                dismiss()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: "Error signing in.",
                    isDismissable: true,
                    dismissAction: .init(
                        title: "Try Again",
                        action: clearCredentials))
            }
        }
    }
    
    private func clearCredentials() {
        email.clear()
        password.clear()
    }
}

#Preview {
    NavigationStack {
        SignInView()
            .environment(AuthHandler())
    }
}
