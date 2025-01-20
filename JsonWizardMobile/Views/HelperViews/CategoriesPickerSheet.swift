//
//  CategoriesPickerSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import SwiftUI

struct CategoriesPickerSheet: View {
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var question: Question
    
    private var categories: [Category] {
        store.categoriesObject.categories
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    var isBinded = store.isBound(category: category, with: question)
                    HStack{
                        Text(category.title)
                        Spacer()
                        Button(action: {
                            bind(category: category)
                        }) {
                            Image(systemName: isBinded ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            }
            .navigationTitle("choose_categories")
            .toolbar {
                toolbarOKButton
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarOKButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("OK") { dismiss() }
        }
    }
    
    private func bind(category: Category) {
        var isBinded = store.isBound(category: category, with: question)
        if isBinded {
            store.unbind(category: category, from: question)
        } else {
            store.bind(category: category, with: question)
        }
    }
}

#Preview {
    CategoriesPickerSheet(question: Question.sampleData[0])
        .environment(\.store, .init(categoriesObject: .init(categories: [
            .init(
                id: 0,
                title: "First Aid",
                subtitle: "Something about first aid",
                color: .pink),
            .init(
                id: 1,
                title: "Obesity"),
            .init(
                id: 2,
                title: "Diabetes")
        ])))
}
