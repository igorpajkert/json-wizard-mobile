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
    @State private var database: DatabaseController
    @State private var authentication: Authentication
    @State private var errorWrapper: ErrorWrapper?
    
    @State private var isPresentingSignInSheet = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    private var isUserValid: Bool {
        Authentication.isUserValid
    }
    
    // MARK: App Initializer
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize state properties
        store = DataStore()
        database = DatabaseController()
        authentication = Authentication()
    }
    
    // MARK: Main App Entry Point
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Categories", systemImage: "square.stack.3d.up") {
                    NavigationStack {
                        CategoriesView()
                            .navigationTitle("Categories")
                    }
                }
                Tab("All Questions", systemImage: "rectangle.stack") {
                    NavigationStack {
                        QuestionsView(questions: store.questionsObject.questions)
                            .navigationTitle("All Questions")
                    }
                }
                Tab("Account", systemImage: "person.crop.circle") {
                    NavigationStack {
                        AccountView()
                            .navigationTitle("Account")
                    }
                }
            }
            .dataStore(store)
            .database(database)
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
            try await store.save(using: database)
        } catch {
            if error as? Authentication.AuthError == .invalidUser {
                errorWrapper = .init(
                    error: error,
                    guidance: "Sign in is required to save data. Please sign into your developer account to continue.",
                    isDismissable: false,
                    dismissAction: .init(title: "Sign In", action: presentSignInSheet))
            } else {
                errorWrapper = ErrorWrapper(
                    error: error,
                    guidance: "Error saving data. Please retry later.",
                    isDismissable: true)
            }
        }
    }
    
    private func load() async {
        do {
            try await store.load(using: database)
        } catch {
            if error as? Authentication.AuthError == .invalidUser {
                errorWrapper = .init(
                    error: error,
                    guidance: "Sign in is required to load data. Please sign into your developer account to continue.",
                    isDismissable: false,
                    dismissAction: .init(title: "Sign In", action: presentSignInSheet))
            } else {
                errorWrapper = .init(
                    error: error,
                    guidance: "Error loading data. Restart the app and retry.",
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
