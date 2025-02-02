//
//  AccountView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 10/01/2025.
//

import SwiftUI

struct AccountView: View {
    
    @State private var viewModel = AccountView.ViewModel()
    
    @Environment(\.auth) private var auth
    
    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                mainVStack
                    .sheet(
                        isPresented: $viewModel.isPresentingSignInSheet,
                        onDismiss: viewModel.dismissSignInSheet
                    ) {
                        SignInSheet()
                    }
                    .sheet(
                        isPresented: $viewModel.isPresentingPasswordChangeSheet,
                        onDismiss: viewModel.dismissPasswordChangeSheet
                    ) {
                        PasswordChangeSheet()
                    }
                    .sheet(item: $viewModel.errorWrapper) { wrapper in
                        ErrorSheet(errorWrapper: wrapper)
                    }
                    .padding()
                    .task {
                        await viewModel.fetchUserData()
                    }
                    .onAppear {
                        if !viewModel.isSet {
                            viewModel.set(auth: auth)
                        }
                    }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.lightLavender, .lavender]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(.all)
    }
    
    private var mainVStack: some View {
        VStack(spacing: 16) {
            avatarImage
            userInfo
            Divider()
            Spacer()
            if !viewModel.isUserSignedIn {
                signInButton
            }
            changePasswordButton
            signOutButton
        }
    }
    
    private var avatarImage: some View {
        Image(viewModel.userAvatar)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
    private var userInfo: some View {
        Group {
            Text(viewModel.userName)
                .font(.title)
                .fontWeight(.semibold)
            Text(viewModel.userEmail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(viewModel.userRole)
                .foregroundStyle(.secondary)
        }
    }
    
    private var signInButton: some View {
        Button(action: viewModel.presentSignInSheet) {
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
        Button(action: viewModel.presentPasswordChangeSheet) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("button_change_password")
                    .foregroundStyle(.accent.adaptedTextColor())
                    .padding()
            }
        }
        .isHidden(!viewModel.isUserSignedIn)
        .padding(.horizontal)
    }
    
    private var signOutButton: some View {
        Button(role: .destructive, action: viewModel.signOut) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                Text("button_sign_out")
                    .foregroundStyle(.red.adaptedTextColor())
                    .padding()
            }
        }
        .isHidden(!viewModel.isUserSignedIn)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        AccountView()
            .navigationTitle("Account")
            .environment(Authentication())
    }
}
