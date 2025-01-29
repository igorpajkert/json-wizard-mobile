//
//  SignInSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

struct SignInSheet: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorWrapper: ErrorWrapper?
    @State private var isShowingPasswordResetSheet = false
    
    @Environment(\.auth) private var auth
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
                    ErrorSheet(errorWrapper: wrapper)
                }
                .sheet(isPresented: $isShowingPasswordResetSheet, onDismiss: dismissPasswordResetSheet) {
                    PasswordResetSheet()
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
            Text("sign_in_sheet_info")
                .font(.headline)
            Text("account_help_info")
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
    
    private var passwordResetButton: some View {
        Button(action: showPasswordResetSheet) {
            Text("forgot_password")
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
                try await auth.signIn(with: email, password: password)
                dismiss()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_sign_in_failed"),
                    isDismissable: true,
                    dismissAction: .init(
                        title: String(localized: "action_try_again"),
                        action: clearCredentials
                    )
                )
            }
        }
    }
    
    private func clearCredentials() {
        email.clear()
        password.clear()
    }
    
    private func showPasswordResetSheet() {
        isShowingPasswordResetSheet = true
    }
    
    private func dismissPasswordResetSheet() {
        isShowingPasswordResetSheet = false
    }
}

#Preview {
    NavigationStack {
        SignInSheet()
            .environment(Authentication())
    }
}
