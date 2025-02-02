//
//  AccountView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/02/2025.
//

import SwiftUI

extension AccountView {
    
    @Observable
    class ViewModel {
        
        var isPresentingSignInSheet = false
        var isPresentingPasswordChangeSheet = false
        var errorWrapper: ErrorWrapper?
        
        var isSet = false
        
        private var auth = Authentication()
        
        private let stringKeys = (
            user: String(localized: "text_user"),
            email: String(localized: "text_email"),
            role: String(localized: "text_role")
        )
        
        var userName: String { auth.userData?.name ?? stringKeys.user }
        var userEmail: String { auth.user?.email ?? stringKeys.email }
        var userRole: String { auth.userData?.role?.name ?? stringKeys.role }
        var userAvatar: ImageResource { .avatarWhite }
        var isUserSignedIn: Bool { auth.user != nil }
        
        func set(auth: Authentication) {
            self.auth = auth
            isSet = true
        }
        
        func fetchUserData() async {
            do {
                try await auth.fetchUserData()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_could_not_fetch_user_data"),
                    isDismissable: true,
                    dismissAction: .init(
                        title: String(localized: "action_sign_in"),
                        action: presentSignInSheet
                    )
                )
            }
        }
        
        // MARK: Intents
        func presentSignInSheet() {
            isPresentingSignInSheet = true
        }
        
        func dismissSignInSheet() {
            isPresentingSignInSheet = false
        }
        
        func presentPasswordChangeSheet() {
            isPresentingPasswordChangeSheet = true
        }
        
        func dismissPasswordChangeSheet() {
            isPresentingPasswordChangeSheet = false
        }
        
        func signOut() {
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
}
