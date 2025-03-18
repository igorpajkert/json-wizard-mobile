//
//  MainModeView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 18/03/2025.
//

import SwiftUI

struct MainModeView: View {
    
    enum MainModeSelection {
        case categories
        case questions
    }
    
    @State private var selection = MainModeSelection.categories
    
    var body: some View {
        switch selection {
        case .categories:
            CategoriesView()
                .navigationTitle("title_categories")
        case .questions:
            QuestionsView(parentCategory: nil)
                .navigationTitle("title_all_questions")
        }
        Picker("picker_main_mode", selection: $selection) {
            Text("picker_categories").tag(MainModeSelection.categories)
            Text("picker_questions").tag(MainModeSelection.questions)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom)
        .padding(.top, 6)
    }
}

#Preview {
    NavigationStack {
        MainModeView()
    }
}
