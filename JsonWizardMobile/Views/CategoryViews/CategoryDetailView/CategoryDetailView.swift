//
//  CategoryDetailView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @State private var viewModel = CategoryDetailView.ViewModel()
    
    @Environment(\.store) private var store
    
    let category: Category
    
    var body: some View {
        List {
            categoryInfo
            CategoryProductionInfo(
                lastTransferDate: viewModel.lastProductionTransfer,
                needsUpdate: viewModel.needsUpdate
            )
            questions
            questionsPreview
        }
        .navigationTitle(viewModel.category.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            toolbarEditButton
        }
        .sheet(
            isPresented: $viewModel.isPresentingEditCategorySheet,
            onDismiss: viewModel.dismissEditViewSheet
        ) {
            CategoryEditSheet(category: viewModel.category)
        }
        .onAppear {
            if !viewModel.isSet {
                viewModel.set(store: store, category: category)
            }
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
            Text(viewModel.category.title)
                .foregroundStyle(.secondary)
        }
    }
    
    private var categorySubtitle: some View {
        HStack {
            Text("category_subtitle_text")
            Spacer()
            Text(viewModel.category.subtitle ?? "")
                .foregroundStyle(.secondary)
        }
    }
    
    private var categoryStatus: some View {
        HStack {
            Text("category_status_text")
            Spacer()
            CategoryStatusBadge(category: viewModel.category)
                .foregroundStyle(.secondary)
        }
    }
    
    private var categoryColor: some View {
        HStack {
            Text("category_color_text")
            Spacer()
            Circle()
                .fill(viewModel.category.unwrappedColor)
                .frame(width: 16, height: 16)
        }
    }
    
    private var questions: some View {
        Section(header: Text("Questions")) {
            NavigationLink(destination: { QuestionsView(parentCategory: viewModel.category) }) {
                Label("label_edit_questions", systemImage: "rectangle.stack.badge.plus")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
            HStack {
                Text("Count")
                Spacer()
                Text(String(viewModel.category.questionsCount))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var questionsPreview: some View {
        Section {
            ForEach(viewModel.categoryQuestions) { question in
                Text(question.questionText)
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarEditButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Edit", action: viewModel.presentEditViewSheet)
        }
    }
}

#Preview("General Knowledge") {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[0])
    }
}
