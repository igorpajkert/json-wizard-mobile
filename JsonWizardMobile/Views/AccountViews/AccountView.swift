//
//  AccountView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 10/01/2025.
//

import SwiftUI

struct AccountView: View {
    
    @State private var isPresentingSignInSheet = false
    @State private var isPresentingPasswordChangeSheet = false
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.auth) private var auth
    
    private let stringKeys = (
        user: String(localized: "text_user"),
        email: String(localized: "text_email")
    )
    
    private var userName: String { auth.user?.displayName ?? stringKeys.user }
    private var userEmail: String { auth.user?.email ?? stringKeys.email }
    private var userRole: String { "Administrator" } // FIXME: Role
    private var userAvatar: ImageResource { .avatarWhite } // FIXME: Avatar
    private var isUserSignedIn: Bool { auth.user != nil }
    
    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                mainVStack
                    .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
                        SignInSheet()
                    }
                    .sheet(isPresented: $isPresentingPasswordChangeSheet, onDismiss: dismissPasswordChangeSheet) {
                        PasswordChangeSheet()
                    }
                    .sheet(item: $errorWrapper) { wrapper in
                        ErrorSheet(errorWrapper: wrapper)
                    }
                    .padding()
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.lightLavender, .lavender]),
            startPoint: .top,
            endPoint: .bottom)
        .ignoresSafeArea(.all)
    }
    
    private var mainVStack: some View {
        VStack(spacing: 16) {
            avatarImage
            userInfo
            Divider()
            Spacer()
            if !isUserSignedIn {
                signInButton
            }
            changePasswordButton
            signOutButton
        }
    }
    
    private var avatarImage: some View {
        Image(userAvatar)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var userInfo: some View {
        Group {
            Text(userName)
                .font(.title)
                .fontWeight(.semibold)
            Text(userEmail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(userRole)
                .foregroundStyle(.secondary)
        }
    }
    
    private var signInButton: some View {
        Button(action: presentSignInSheet) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("button_sign_in")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .bold()
                    .padding()
            }
        }
        .padding(.horizontal)
    }
    
    private var changePasswordButton: some View {
        Button(action: presentPasswordChangeSheet) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("button_change_password")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .isHidden(!isUserSignedIn)
        .padding(.horizontal)
    }
    
    private var signOutButton: some View {
        Button(role: .destructive, action: signOut) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("button_sign_out")
                    .foregroundStyle(.red.adaptedTextColor())
                    .padding()
            }
        }
        .isHidden(!isUserSignedIn)
        .padding(.horizontal)
    }
    
    // MARK: - Intents
    private func presentSignInSheet() {
        isPresentingSignInSheet = true
    }
    
    private func dismissSignInSheet() {
        isPresentingSignInSheet = false
    }
    
    private func presentPasswordChangeSheet() {
        isPresentingPasswordChangeSheet = true
    }
    
    private func dismissPasswordChangeSheet() {
        isPresentingPasswordChangeSheet = false
    }
    
    private func signOut() {
        do {
            try auth.signOut()
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: String(localized: "guidance_sign_out_error"),
                isDismissable: true
            )
        }
    }
}

#Preview {
    NavigationStack {
        AccountView()
            .navigationTitle("Account")
            .environment(Authentication())
    }
}
