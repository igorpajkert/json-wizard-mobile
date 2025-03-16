//
//  MainView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/02/2025.
//

import Foundation

extension MainView {
    
    @Observable
    class ViewModel {
        
        var isPresentingSignInSheet = false
        var errorWrapper: ErrorWrapper?
        
        var isUserSignedIn: Bool {
            Authentication.shared.isUserSignedIn
        }
        
        // MARK: Intents
        func presentSignInSheet() {
            isPresentingSignInSheet = true
        }
        
        func dismissSignInSheet() {
            isPresentingSignInSheet = false
        }
    }
}
