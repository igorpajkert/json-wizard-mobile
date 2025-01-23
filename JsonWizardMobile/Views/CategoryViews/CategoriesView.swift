//
//  CategoriesView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var isPresentingNewCategorySheet = false
    @State private var isPresentingSignInSheet = false
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment(\.store) private var store
    @Environment(\.database) private var database
    
    private var isCategoriesEmpty: Bool {
        store.categoriesObject.categories.isEmpty
    }
    
    var body: some View {
        List {
            categoriesList
            categoriesCount.isHidden(isCategoriesEmpty)
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
        }
        .sheet(isPresented: $isPresentingNewCategorySheet, onDismiss: dismissNewCategorySheet) {
            //FIXME: View Model
            CategoryEditSheet(category: Category(),
                              editorTitle: "Add Category",
                              isNewCategory: true)
        }
        .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
            SignInSheet()
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .refreshable {
            await refresh()
        }
        .overlay(alignment: .center) {
            if isCategoriesEmpty {
                ContentUnavailableView("add_first_category_text", systemImage: "widget.extralarge.badge.plus")
            }
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
    
    private var categoriesCount: some View {
        Text("\(store.categoriesObject.categories.count) categories_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
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
        } catch Authentication.AuthError.invalidUser {
            errorWrapper = .init(
                error: Authentication.AuthError.invalidUser,
                guidance: "Could not refresh categories. Sign in to continue.",
                isDismissable: true,
                dismissAction: .init(title: "Sign In", action: presentSignInSheet))
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: "Could not refresh categories. Check if you are properly signed in and try again.",
                isDismissable: true)
        }
    }
    
    private func presentSignInSheet() {
        isPresentingSignInSheet = true
    }
    
    private func dismissSignInSheet() {
        isPresentingSignInSheet = false
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
            .environment(\.store, DataStore(categoriesObject: Categories(categories: Category.sampleData)))
            .environment(\.database, DatabaseController())
    }
}
