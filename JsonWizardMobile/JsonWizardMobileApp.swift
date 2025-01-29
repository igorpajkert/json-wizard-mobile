//
//  JsonWizardMobileApp.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import SwiftUI
import FirebaseCore

@main
struct JsonWizardMobileApp: App {
    
    @State private var store: DataStore
    @State private var authentication: Authentication
    @State private var errorWrapper: ErrorWrapper?
    
    @State private var isPresentingSignInSheet = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    private var isUserValid: Bool {
        Authentication.isUserValid
    }
    
    init() {
        FirebaseApp.configure()
        
        store = DataStore()
        authentication = Authentication()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("tab_categories", systemImage: "square.stack.3d.up") {
                    NavigationStack {
                        CategoriesView()
                            .navigationTitle("title_categories")
                    }
                }
                Tab("tab_all_questions", systemImage: "rectangle.stack") {
                    NavigationStack {
                        QuestionsView(parentCategory: nil)
                            .navigationTitle("title_all_questions")
                    }
                }
                Tab("tab_account", systemImage: "person.crop.circle") {
                    NavigationStack {
                        AccountView()
                            .navigationTitle("title_account")
                    }
                }
            }
            .dataStore(store)
            .auth(authentication)
            .sheet(item: $errorWrapper) { wrapper in
                ErrorSheet(errorWrapper: wrapper)
            }
            .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
                SignInSheet()
            }
            .task {
                if isUserValid {
                    await load()
                } else {
                    presentSignInSheet()
                }
            }
            .onChange(of: scenePhase) { oldState, newState in
                if newState == .inactive && !isPresentingSignInSheet {
                    guard isUserValid else { return }
                    Task {
                        await save()
                    }
                }
            }
            .onChange(of: isPresentingSignInSheet) { oldState, newState in
                if isUserValid && newState == false {
                    Task {
                        await load()
                    }
                }
            }
        }
    }
    
    // MARK: - Data Handling Methods
    private func save() async {
        do {
            try await store.save()
        } catch {
            if error as? Authentication.AuthError == .invalidUser {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_save_sign_in_required"),
                    isDismissable: false,
                    dismissAction: .init(
                        title: String(localized: "action_sign_in"),
                        action: presentSignInSheet
                    )
                )
            } else {
                errorWrapper = ErrorWrapper(
                    error: error,
                    guidance: String(localized: "guidance_error_saving_data_generic"),
                    isDismissable: true)
            }
        }
    }
    
    private func load() async {
        do {
            try await store.load()
        } catch {
            if error as? Authentication.AuthError == .invalidUser {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_load_sign_in_required"),
                    isDismissable: false,
                    dismissAction: .init(
                        title: String(localized: "action_sign_in"),
                        action: presentSignInSheet
                    )
                )
            } else {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_error_loading_data_generic"),
                    isDismissable: true)
            }
        }
    }
    
    // MARK: - UI Presentation Methods
    private func presentSignInSheet() {
        isPresentingSignInSheet = true
    }
    
    private func dismissSignInSheet() {
        isPresentingSignInSheet = false
    }
}
