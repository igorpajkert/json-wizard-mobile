//
//  QuestionEditView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 23/01/2025.
//

import SwiftUI

extension QuestionEditView {
    
    @Observable
    class ViewModel {
        
        var isPresentingCategoriesPickerSheet = false
        
        private let store: DataStore
        private let question: Question
        private let parentCategory: Category?
        
        var categories: [Category] {
            var categories = store.getCategories(of: question.categoryIDs)
            if let parentCategory = parentCategory {
                categories.append(parentCategory)
            }
            return categories
        }
        
        init(
            store: DataStore,
            question: Question,
            parentCategory: Category?
        ) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
        }
        
        func addAnswer(with text: Binding<String>) {
            withAnimation {
                store.addAnswer(at: question, with: text.wrappedValue)
                text.wrappedValue.clear()
            }
        }
        
        func deleteAnswers(at offsets: IndexSet) {
            store.deleteAnswers(at: question, with: offsets)
        }
        
        func presentCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = true
        }
        
        func dismissCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = false
        }
    }
}
