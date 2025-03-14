//
//  CategoriesPickerSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import SwiftUI

struct CategoriesPickerSheet: View {
    
    @State private var viewModel = CategoriesPickerSheet.ViewModel()
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var question: Question
    var parentCategory: Category?
    var viewType: QuestionViewType
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.categories) { category in
                    HStack {
                        ScrollView(.horizontal) {
                            CategoryBadge(category: category)
                        }
                        .scrollIndicators(.never)
                        Spacer()
                        Button(action: {
                            viewModel.onCategorySelected(category)
                        }) {
                            Image(systemName: viewModel.image(for: category))
                        }
                        .disabled(parentCategory == category)
                    }
                }
            }
            .navigationTitle("choose_categories")
            .toolbar {
                toolbarOKButton
            }
            .sheet(item: $viewModel.errorWrapper) { wrapper in
                ErrorSheet(errorWrapper: wrapper)
            }
            .overlay(alignment: .center) {
                if viewModel.categories.isEmpty {
                    ContentUnavailableView(
                        "CU_title_add_category",
                        systemImage: "widget.extralarge.badge.plus",
                        description: Text("CU_description_add_category")
                    )
                }
            }
            .onAppear {
                if !viewModel.isSet {
                    viewModel.set(
                        store: store,
                        question: question,
                        parentCategory: parentCategory,
                        viewType: viewType
                    )
                }
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarOKButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("button_done") { dismiss() }
        }
    }
}

#Preview("Data") {
    CategoriesPickerSheet(question: Question.sampleData[0], viewType: .new)
        .environment(\.store, .init(categories: [
            .init(title: "Obesity"),
            .init(title: "General Knowledge"),
            .init(title: "Mental Health")
        ]))
}

#Preview("No data") {
    CategoriesPickerSheet(question: Question.sampleData[0], viewType: .edit)
}
