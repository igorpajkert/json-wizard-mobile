//
//  AccountView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 10/01/2025.
//

import SwiftUI

struct AccountView: View {
    
    @State private var isPresentingSignInSheet = false
    
    @Environment(\.authHandler) private var authHandler
    
    var body: some View {
        VStack(spacing: 16) {
            Image(.avatarW)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 4)
            Text("Igor Pajkert")
                .font(.title)
                .fontWeight(.semibold)
            Text("pajkert.igor@gmail.com")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Administrator")
                .foregroundStyle(.secondary)
            Divider()
            Button("Edit Profile") {}
                .frame(minWidth: 150, minHeight: 35)
                .background(RoundedRectangle(cornerRadius: 64).fill(.accent))
                .foregroundStyle(.accent.adaptedTextColor())
            Text(authHandler.user?.uid ?? "user nil")
            Text(authHandler.user?.email ?? "email nil")
            Button("Sign In") {
                presentSignInSheet()
            }
            Spacer()
            Button("Log Out") {
                try? authHandler.signOut()
            }
                .foregroundStyle(.red)
        }
        .padding()
        .sheet(isPresented: $isPresentingSignInSheet,
               onDismiss: dismissSignInSheet) {
            SignInView()
        }
    }
    
    // MARK: - Intents
    private func presentSignInSheet() {
        isPresentingSignInSheet = true
    }
    
    private func dismissSignInSheet() {
        isPresentingSignInSheet = false
    }
}

#Preview {
    AccountView()
        .environment(AuthHandler())
}
