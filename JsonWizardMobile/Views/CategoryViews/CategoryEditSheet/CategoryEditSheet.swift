//
//  CategoryEditSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryEditSheet: View {
    
    @State private var viewModel = CategoryEditSheet.ViewModel()
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var category: Category?
    
    var body: some View {
        NavigationStack {
            form
                .navigationTitle(viewModel.editorTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarSaveButton
                    toolbarCancleButton
                }
                .sheet(item: $viewModel.errorWrapper) { wrapper in
                    ErrorSheet(errorWrapper: wrapper)
                }
                .onAppear {
                    if !viewModel.isSet {
                        viewModel.set(category: category, store: store)
                    }
                }
        }
    }
    
    private var form: some View {
        Form {
            Section("section_category_info") {
                TextField("text_title",
                          text: $viewModel.title,
                          axis: .vertical)
                TextField("text_subtitle",
                          text: $viewModel.subtitle,
                          axis: .vertical)
                ColorPicker("picker_color",
                            selection: $viewModel.color)
            }
            Section("section_status") {
                Picker("picker_status", selection: $viewModel.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.name).tag(status as Status)
                    }
                }
                .pickerStyle(.menu)
                .tint(viewModel.status.mainColor)
            }
            creationDate
        }
    }
    
    private var creationDate: some View {
        Text("text_date_created \(viewModel.dateCreated.formatted(date: .long, time: .shortened))")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Toolbar
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("button_save") {
                withAnimation {
                    viewModel.save()
                    dismiss()
                }
            }
            .disabled(viewModel.title.isEmpty)
        }
    }
    
    private var toolbarCancleButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("button_cancel", role: .cancel) {
                dismiss()
            }
        }
    }
}

#Preview("Add Category") {
    CategoryEditSheet()
    
}
#Preview("Edit Category") {
    CategoryEditSheet(category: Category.sampleData[0])
}
