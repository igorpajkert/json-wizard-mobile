//
//  ReauthenticateSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 14/01/2025.
//

import SwiftUI

struct ReauthenticateSheet: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.dismiss) private var dismiss
    
    private let auth = Authentication.shared
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 16) {
                    infoText
                    userCredentials
                    authenticateButton
                }
                .navigationTitle("Sign In")
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
        Image(.auth)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var infoText: some View {
        Group {
            sampleImage
            Text("reauthenticate_sheet_info")
                .font(.headline)
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
    
    private var authenticateButton: some View {
        Button(action: authenticate) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("Authenticate")
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
    private func authenticate() {
        Task {
            do {
                try await auth.reauthenticateUser(with: email, password: password)
                dismiss()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_reauthentication_failed"),
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
}

#Preview {
    NavigationStack {
        ReauthenticateSheet()
    }
}
