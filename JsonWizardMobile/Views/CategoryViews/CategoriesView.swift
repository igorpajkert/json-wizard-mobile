//
//  CategoriesView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var isPresentingNewCategorySheet = false
    
    @Environment(\.store) private var store
    
    var body: some View {
        List {
            categoriesList
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
        }
        .sheet(isPresented: $isPresentingNewCategorySheet,
               onDismiss: dismissNewCategorySheet) {
            CategoryEditSheet(category: store.createEmptyCategory(),
                              editorTitle: "Add Category")
        }
    }
    
    private var categoriesList: some View {
        ForEach(store.categories) { category in
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
}

#Preview {
    NavigationStack {
        CategoriesView()
            .environment(\.store, DataStore(categories: Category.sampleData))
    }
}
