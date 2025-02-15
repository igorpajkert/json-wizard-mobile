//
//  CategoriesView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var viewModel = CategoriesView.ViewModel()
    
    @Environment(\.store) private var store
    
    var body: some View {
        List {
            categoriesList
            categoriesCount.isHidden(viewModel.isCategoriesEmpty)
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
        }
        .navigationDestination(for: Category.self) { category in
            CategoryDetailView(category: category)
        }
        .sheet(
            isPresented: $viewModel.isPresentingNewCategorySheet,
            onDismiss: viewModel.dismissNewCategorySheet
        ) {
            CategoryEditSheet()
        }
        .sheet(
            isPresented: $viewModel.isPresentingSignInSheet,
            onDismiss: viewModel.dismissSignInSheet
        ) {
            SignInSheet()
        }
        .sheet(item: $viewModel.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .overlay(alignment: .center) {
            if viewModel.isCategoriesEmpty {
                ContentUnavailableView(
                    "add_first_category_text",
                    systemImage: "widget.extralarge.badge.plus"
                )
            }
        }
        .onAppear {
            if !viewModel.isSet {
                viewModel.set(store: store)
            }
        }
    }
    
    private var categoriesList: some View {
        ForEach(viewModel.categories) { category in
            NavigationLink(value: category) {
                CategoryCardView(category: category)
            }
        }
        .onDelete(perform: viewModel.deleteCategories)
    }
    
    private var categoriesCount: some View {
        Text("\(viewModel.categories.count) categories_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Toolbar
    private var toolbarAddButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: viewModel.presentNewCategorySheet) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview("Sample Data") {
    NavigationStack {
        CategoriesView()
            .navigationTitle("Categories")
            .environment(\.store, DataStore(questions: Question.sampleData))
    }
}

#Preview("No Data") {
    NavigationStack {
        CategoriesView()
            .navigationTitle("Categories")
            .environment(\.store, DataStore())
    }
}
