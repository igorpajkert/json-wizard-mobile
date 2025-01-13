//
//  AccountView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 10/01/2025.
//

import SwiftUI

struct AccountView: View {
    
    @State private var isPresentingSignInSheet = false
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.authHandler) private var authHandler
    
    private var userName: String { authHandler.user?.displayName ?? "User" }
    private var userEmail: String { authHandler.user?.email ?? "Email Address" }
    private var userRole: String { "Administrator" } // FIXME: Role
    private var userAvatar: ImageResource { .avatarIgor } // FIXME: Avatar
    private var isUserSignedIn: Bool { authHandler.user != nil }
    
    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                mainVStack
                    .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
                        SignInView()
                    }
                    .sheet(item: $errorWrapper) { wrapper in
                        ErrorView(errorWrapper: wrapper)
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
                Text("Sign In")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .bold()
                    .padding()
            }
        }
        .padding(.horizontal)
    }
    
    // TODO: Change Password
    private var changePasswordButton: some View {
        Button(action:{}) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("Change Password")
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
                Text("Sign Out")
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
    
    private func signOut() {
        do {
            try authHandler.signOut()
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: "Could not sign out.",
                isDismissable: true)
        }
    }
}

#Preview {
    NavigationStack {
        AccountView()
            .navigationTitle("Account")
            .environment(AuthHandler())
    }
}
