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
            .onChange(of: scenePhase) { oldState, newState in
                if newState == .inactive {
                    do {
                        try store.save(using: database)
                    } catch {
                        print("Error saving data: \(error.localizedDescription)")
                    }
                }
            }
            .task {
                do {
                    try await store.load(using: database)
                } catch {
                    print("Error loading data: \(error.localizedDescription)")
                }
            }
        }
    }
}
