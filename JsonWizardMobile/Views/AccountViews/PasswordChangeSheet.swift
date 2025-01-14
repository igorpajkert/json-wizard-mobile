//
//  PasswordChangeSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 14/01/2025.
//

import SwiftUI

struct PasswordChangeSheet: View {
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorWrapper: ErrorWrapper?
    @State private var isPresentingReauthenticateSheet = false
    
    @Environment(\.authHandler) private var authHandler
    @Environment(\.dismiss) private var dismiss
    
    private var isPasswordsMatch: Bool {
        password == confirmPassword
    }
    
    private var isPasswordsEmpty: Bool {
        password.isEmpty || confirmPassword.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    infoText
                    userPasswords
                    if !isPasswordsEmpty {
                        passwordsMatchIndicator
                    }
                    changePasswordButton
                }
                .navigationTitle("Change Password")
                .toolbar {
                    toolbarDismissButton
                }
                .sheet(isPresented: $isPresentingReauthenticateSheet, onDismiss: dismissReauthenticateSheet) {
                    ReauthenticateSheet()
                }
                .sheet(item: $errorWrapper) { wrapper in
                    ErrorSheet(errorWrapper: wrapper)
                }
                .padding()
            }
        }
    }
    
    private var sampleImage: some View {
        Image(.password)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var infoText: some View {
        Group {
            sampleImage
            Text("Change the password for your account.")
                .font(.headline)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    private var userPasswords: some View {
        Group {
            SecureField("New password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 32).stroke(style: StrokeStyle(lineWidth: 2)))
            SecureField("Confirm new password", text: $confirmPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 32).stroke(style: StrokeStyle(lineWidth: 2)))
        }
        .textInputAutocapitalization(.never)
        .padding(.horizontal)
    }
    
    private var passwordsMatchIndicator: some View {
        Label("Passwords match", systemImage: isPasswordsMatch ? "checkmark" : "xmark")
            .foregroundStyle(isPasswordsMatch ? .green : .red)
    }
    
    private var changePasswordButton: some View {
        Button(action: changePassword) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("Change Password")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .disabled(isPasswordsEmpty || !isPasswordsMatch)
        .padding()
    }
    
    // MARK: Toolbar
    private var toolbarDismissButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Dismiss") { dismiss() }
        }
    }
    
    // MARK: - Intents
    func changePassword() {
        Task {
            do {
                try await authHandler.updatePassword(to: password)
                dismiss()
            } catch {
                if error as? AuthHandler.AuthError == AuthHandler.AuthError.reauthenticationRequired {
                    errorWrapper = .init(
                        error: error,
                        guidance: "Re-authentication required. Please sign into your account and try again.",
                        isDismissable: true,
                        dismissAction: .init(title: "Authenticate", action: presentReauthenticateSheet))
                } else {
                    errorWrapper = .init(
                        error: error,
                        guidance: "Unable to change password. Please try again.",
                        isDismissable: true,
                        dismissAction: .init(title: "Try Again", action: clearPasswords))
                }
            }
        }
    }
    
    private func clearPasswords() {
        password.clear()
        confirmPassword.clear()
    }
    
    private func presentReauthenticateSheet() {
        isPresentingReauthenticateSheet = true
    }
    
    private func dismissReauthenticateSheet() {
        isPresentingReauthenticateSheet = false
    }
}

#Preview {
    NavigationStack {
        PasswordChangeSheet()
            .environment(AuthHandler())
    }
}
