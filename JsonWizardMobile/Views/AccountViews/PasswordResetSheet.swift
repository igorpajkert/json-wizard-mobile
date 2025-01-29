//
//  PasswordResetSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 12/01/2025.
//

import SwiftUI

struct PasswordResetSheet: View {
    
    @State private var email: String = ""
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.auth) private var auth
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    infoText
                    userEmail
                    sendEmailButton
                }
                .navigationTitle("Reset Password")
                .toolbar {
                    toolbarDismissButton
                }
                .sheet(item: $errorWrapper) { wrapper in
                    ErrorSheet(errorWrapper: wrapper)
                }
                .padding()
            }
        }
    }
    
    private var sampleImage: some View {
        Image(.email)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var infoText: some View {
        Group {
            sampleImage
            Text("password_reset_email")
                .font(.headline)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    private var userEmail: some View {
        TextField("Email", text: $email)
            .padding()
            .background(RoundedRectangle(cornerRadius: 32).stroke(style: StrokeStyle(lineWidth: 2)))
            .textInputAutocapitalization(.never)
            .padding(.horizontal)
    }
    
    private var sendEmailButton: some View {
        Button(action: sendEmail) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("Send Email")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .disabled(email.isEmpty)
        .padding()
    }
    
    // MARK: Toolbar
    private var toolbarDismissButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Dismiss") { dismiss() }
        }
    }
    
    // MARK: - Intents
    private func sendEmail() {
        Task {
            do {
                try await auth.sendPasswordResetEmail(to: email)
                dismiss()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_auth_email_send_failed"),
                    isDismissable: true,
                    dismissAction: .init(
                        title: String(localized: "action_try_again"),
                        action: clearEmail
                    )
                )
            }
        }
    }
    
    private func clearEmail() {
        email.clear()
    }
}

#Preview {
    NavigationStack {
        PasswordResetSheet()
            .environment(Authentication())
    }
}
