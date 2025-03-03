//
//  CategoryMigrationSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/03/2025.
//

import SwiftUI

struct CategoryMigrationSheet: View {
    
    @State private var viewModel = CategoryMigrationSheet.ViewModel()
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    let category: Category
    
    var body: some View {
        NavigationStack {
            Form {
                sectionSelectedCategory
                CategoryProductionInfo(
                    lastTransferDate: viewModel.lastProductionTransfer,
                    needsUpdate: viewModel.needsUpdate
                )
                sectionMigrationDetails
                sectionActions
            }
            .navigationTitle("title_migration")
            .sheet(item: $viewModel.errorWrapper) { wrapper in
                ErrorSheet(errorWrapper: wrapper)
            }
            .onAppear {
                viewModel.set(category: category, store: store)
            }
        }
    }
    
    var sectionSelectedCategory: some View {
        Section("section_selected_category") {
            CategoryCardView(category: viewModel.category)
        }
    }
    
    var sectionMigrationDetails: some View {
        Section("section_migration_details") {
            HStack {
                Text("text_migrate_from")
                Spacer()
                Text(viewModel.currentCollection.rawValue)
                    .foregroundStyle(.secondary)
            }
            Picker("picker_migrate_to", selection: $viewModel.selection) {
                ForEach(viewModel.allowedSelection) { type in
                    Text(type.rawValue).tag(type as DataStore.CollectionType)
                }
            }
        }
    }
    
    var sectionActions: some View {
        Section {
            Button("button_migrate", role: .destructive) {
                viewModel.onMigrateTapped()
                dismiss()
            }
            Button("button_cancel") {
                dismiss()
            }
        }
    }
}

#Preview {
    CategoryMigrationSheet(
        category: .init(title: "Test", color: .indigo)
    )
}
