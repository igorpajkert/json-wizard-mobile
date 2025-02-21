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
            if viewModel.isAdmin {
                CollectionPicker(selection: $viewModel.currentCollectionType)
            }
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
        .alert("alert_title_delete_category",
               isPresented: $viewModel.isPresentingDeletionAlert,
               actions: {
            Button("button_delete", role: .destructive) {
                if let indexSet = viewModel.deletionIndexSet {
                    viewModel.deleteCategories(with: indexSet)
                }
            }
            Button("button_cancel",
                   role: .cancel,
                   action: viewModel.dismissDeletionAlert
            )
        }, message: {
            Text("message_delete_category_confirmation")
        })
        .overlay(alignment: .center) {
            if viewModel.isCategoriesEmpty {
                ContentUnavailableView(
                    "add_first_category_text",
                    systemImage: "widget.extralarge.badge.plus"
                )
            }
        }
        .onAppear {
            viewModel.set(store: store)
        }
    }
    
    private var categoriesList: some View {
        ForEach(viewModel.categories) { category in
            NavigationLink(value: category) {
                CategoryCardView(category: category)
            }
        }
        .onDelete(perform: viewModel.presentDeletionAlert)
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

#Preview {
    NavigationStack {
        CategoriesView()
            .navigationTitle("Categories")
    }
}
