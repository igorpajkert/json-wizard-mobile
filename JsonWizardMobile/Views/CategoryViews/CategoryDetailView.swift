//
//  CategoryDetailView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @State private var isPresentingEditCategorySheet = false
    
    @Environment(\.store) private var store
    
    var category: Category
    
    private var categoryQuestions: [Question] {
        store.getQuestions(of: category.questionIDs)
    }
    
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
            categoryTitle
            categorySubtitle
            categoryStatus
            categoryColor
        }
        .multilineTextAlignment(.trailing)
    }
    
    private var categoryTitle: some View {
        HStack {
            Text("category_title_text")
            Spacer()
            Text(category.title)
                .foregroundStyle(.secondary)
        }
    }
    
    private var categorySubtitle: some View {
        HStack {
            Text("category_subtitle_text")
            Spacer()
            Text(category.subtitle ?? "")
                .foregroundStyle(.secondary)
        }
    }
    
    private var categoryStatus: some View {
        HStack {
            Text("category_status_text")
            Spacer()
            CategoryStatusBadge(category: category)
                .foregroundStyle(.secondary)
        }
    }
    
    private var categoryColor: some View {
        HStack {
            Text("category_color_text")
            Spacer()
            Circle()
                .fill(category.unwrappedColor)
                .frame(width: 16, height: 16)
        }
    }
    
    private var questions: some View {
        Section(header: Text("Questions")) {
            NavigationLink(destination: { QuestionsView(parentCategory: category) }) {
                Label("Add Questions", systemImage: "rectangle.stack.badge.plus")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
            HStack {
                Text("Count")
                Spacer()
                Text(String(category.questionsCount))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var questionsPreview: some View {
        Section {
            ForEach(categoryQuestions) { question in
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
