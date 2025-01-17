//
//  CategoriesView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var isPresentingNewCategorySheet = false
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.store) private var store
    @Environment(\.database) private var database
    
    var body: some View {
        List {
            categoriesList
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
        }
        .sheet(isPresented: $isPresentingNewCategorySheet, onDismiss: dismissNewCategorySheet) {
            CategoryEditSheet(category: store.createEmptyCategory(), editorTitle: "Add Category")
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .refreshable {
            await refresh()
        }
    }
    
    private var categoriesList: some View {
        ForEach(store.categoriesObject.categories) { category in
            NavigationLink(destination: CategoryDetailView(category: category)) {
                CategoryCardView(category: category)
            }
        }
        .onDelete(perform: store.deleteCategories)
    }
    
    // MARK: Toolbar
    private var toolbarAddButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: presentNewCategorySheet) {
                Image(systemName: "plus")
            }
        }
    }
    
    // MARK: - Intents
    private func presentNewCategorySheet() {
        isPresentingNewCategorySheet = true
    }
    
    private func dismissNewCategorySheet() {
        isPresentingNewCategorySheet = false
    }
    
    private func refresh() async {
        do {
            try await store.refresh(using: database)
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: "Could not refresh categories. Check if you are properly signed in and try again.",
                isDismissable: true)
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
            .environment(\.store, DataStore(categoriesObject: Categories(categories: Category.sampleData)))
            .environment(\.database, DatabaseController())
    }
}
