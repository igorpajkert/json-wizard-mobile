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
            toolbarSortButton
            toolbarFilterButton
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
        .sheet(
            isPresented: $viewModel.isPresentingMigrationSheet,
            onDismiss: viewModel.onMigrateDismissed
        ) {
            if let category = viewModel.categoryToMigrate {
                CategoryMigrationSheet(category: category)
            }
        }
        .alert("alert_title_delete_category",
               isPresented: $viewModel.isPresentingDeletionAlert,
               actions: {
            Button("button_delete", role: .destructive) {
                viewModel.onDeleteConfirmation()
            }
            Button("button_cancel",
                   role: .cancel,
                   action: viewModel.onDeleteCancelation
            )
        }, message: {
            Text("message_delete_category_confirmation")
        })
        .alert("alert_title_migration_declined",
               isPresented: $viewModel.isPresentingMigrationDeclinedAlert,
               actions: {
            Button("button_ok", action: viewModel.onMigrationDeclinedAlertDismissed)
        }, message: {
            Text("message_migration_declined")
        })
        .searchable(text: $viewModel.searchText)
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
                    .swipeActions(allowsFullSwipe: false) {
                        SwipeButtonDelete {
                            viewModel.onDeleteTapped(category)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        SwipeButtonMigrate {
                            viewModel.onMigrateTapped(with: category)
                        }
                    }
            }
        }
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
    
    private var toolbarSortButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_sort", systemImage: "arrow.up.arrow.down") {
                Picker("picker_sort_by", selection: $viewModel.sortOption) {
                    ForEach(Category.SortOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as Category.SortOptions)
                    }
                }
                Picker("picker_sort_order", selection: $viewModel.sortOrder) {
                    Text("text_sort_ascending").tag(SortOrder.forward)
                    Text("text_sort_descending").tag(SortOrder.reverse)
                }
            }
        }
    }
    
    private var toolbarFilterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_filter", systemImage: "line.3.horizontal.decrease") {
                Picker("picker_filter_by", selection: $viewModel.filterOption) {
                    ForEach(Category.FilterOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as Category.FilterOptions)
                    }
                }
                if viewModel.filterOption == .status {
                    Picker("picker_filter_by_status", selection: $viewModel.selectedStatus) {
                        ForEach(Status.allCases) { status in
                            Text(status.name)
                                .tag(status as Status)
                        }
                    }
                }
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
