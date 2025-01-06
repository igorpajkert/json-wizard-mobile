//
//  CategoryEditSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryEditSheet: View {
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var category: Category
    
    var editorTitle: String?
    
    var body: some View {
        NavigationStack {
            form
                .navigationTitle(editorTitle ?? "Edit Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarSaveButton
                    toolbarCancleButton
                }
        }
    }
    
    private var form: some View {
        Form {
            Section(header: Text("Category Info")) {
                TextField("Title",
                          text: $category.title,
                          axis: .vertical)
                TextField("Subtitle",
                          text: $category.subtitle.unwrapped(),
                          axis: .vertical)
                Picker("Status",
                       selection: $category.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.name).tag(status as Status)
                    }
                }
                ColorPicker("Color", selection: $category.color.unwrapped())
            }
        }
    }
    
    // MARK: Toolbar Intents
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                withAnimation {
                    store.addCategory(category)
                    dismiss()
                }
            }
            .disabled(category.title.isEmpty)
        }
    }
    
    private var toolbarCancleButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
}

#Preview("Add Category") {
    NavigationStack {
        CategoryEditSheet(category: DataStore().createEmptyCategory(), editorTitle: "Add Category")
    }
}
#Preview("Edit Category") {
    NavigationStack {
        CategoryEditSheet(category: Category.sampleData[0])
    }
}
