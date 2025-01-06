//
//  JsonWizardMobileApp.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import SwiftUI

@main
struct JsonWizardMobileApp: App {
    
    // FIXME: Test initialization
    @State private var store = DataStore(categories: Category.sampleData, questions: Question.sampleData)
    
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
                        QuestionsView(questions: store.questions)
                            .navigationTitle("All Questions")
                    }
                }
            }
            .dataStore(store)
        }
    }
}
