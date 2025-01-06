//
//  CategoryDetailView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @State private var isPresentingEditCategorySheet = false
    
    var category: Category
    
    var body: some View {
        List {
            categoryInfo
            questions
            questionsPreview
        }
        .navigationTitle(category.title)
        .toolbar {
            toolbarEditButton
        }
        .sheet(isPresented: $isPresentingEditCategorySheet,
               onDismiss: dismissEditViewSheet) {
            CategoryEditSheet(category: category,
                              editorTitle: "Edit Category")
        }
    }
    
    private var categoryInfo: some View {
        Section(header: Text("Category Info")) {
            HStack {
                Text("Title")
                Spacer()
                Text(category.title)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Subtitle")
                Spacer()
                Text(category.subtitle ?? "")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Status")
                Spacer()
                CategoryStatusBadge(category: category)
                    .foregroundStyle(.secondary)
            }
        }
        .multilineTextAlignment(.trailing)
    }
    
    private var questions: some View {
        Section(header: Text("Questions")) {
            NavigationLink(destination: { QuestionsView(questions: category.questions) }) {
                Label("Add Questions", systemImage: "rectangle.stack.badge.plus")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
            HStack {
                Text("Count")
                Spacer()
                Text("\(category.questionsCount)")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var questionsPreview: some View {
        Section {
            ForEach(category.questions) { question in
                Text(question.questionText)
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarEditButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Edit", action: presentEditViewSheet)
        }
    }
    
    // MARK: - Intents
    private func presentEditViewSheet() {
        isPresentingEditCategorySheet = true
    }
    
    private func dismissEditViewSheet() {
        isPresentingEditCategorySheet = false
    }
}

#Preview("General Knowledge") {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[0])
    }
}

#Preview("First Aid") {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[1])
    }
}

#Preview("Obesity") {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[2])
    }
}

#Preview("Pharmacology Basics") {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[3])
    }
}
