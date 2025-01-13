//
//  JsonWizardMobileApp.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import SwiftUI

@main
struct JsonWizardMobileApp: App {
    
    @State private var store = DataStore()
    @State private var database = DatabaseController()
    @State private var authHandler = AuthHandler()
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.scenePhase) private var scenePhase
    
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
            .authHandler(authHandler)
            .onChange(of: scenePhase) { oldState, newState in
                if newState == .inactive {
                    do {
                        try store.save(using: database)
                    } catch {
                        errorWrapper = ErrorWrapper(
                            error: error,
                            guidance: "Error saving data.",
                            isDismissable: true)
                    }
                }
            }
            .task {
                do {
                    try await store.load(using: database)
                } catch {
                    errorWrapper = ErrorWrapper(
                        error: error,
                        guidance: "Error loading data.",
                        isDismissable: true)
                }
            }
            .sheet(item: $errorWrapper) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}
