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
    private var userAvatar: ImageResource { .avatarW } // FIXME: Avatar
    private var isUserSignedIn: Bool { authHandler.user != nil }
    private var userStatus: String { isUserSignedIn ? "User signed in" : "User signed out" }
    
    var body: some View {
        VStack(spacing: 16) {
            avatarImage
            userInfo
            Divider()
            changePasswordButton
            Spacer()
            signInButton
            signOutButton
            statustext
        }
        .padding(.vertical, 48)
        .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
            SignInView()
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorView(errorWrapper: wrapper)
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
            Text("Sign In")
                .bold()
        }
        .disabled(isUserSignedIn)
        .padding()
    }
    
    // TODO: Change Password
    private var changePasswordButton: some View {
        Button(action:{}) {
            Text("Change Password")
        }
        .disabled(!isUserSignedIn)
        .padding()
    }
    
    private var signOutButton: some View {
        Button(role: .destructive, action: signOut) {
            Text("Sign Out")
        }
        .disabled(!isUserSignedIn)
        .padding()
    }
    
    private var statustext: some View {
        Text(userStatus)
            .font(.caption)
            .foregroundStyle(.secondary)
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
            errorWrapper = .init(error: error,
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
