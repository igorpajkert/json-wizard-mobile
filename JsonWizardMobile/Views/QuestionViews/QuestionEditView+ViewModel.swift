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
        var question = Question()
        var newAnswerText = ""
        
        private(set) var isSet = false
        
        private var store = DataStore()
        private var parentCategory: Category? = nil
        
        var categories: [Category] {
            var categories = store.getCategories(of: question.categoryIDs)
            if let parentCategory = parentCategory {
                categories.append(parentCategory)
            }
            return categories
        }
        
        func set(store: DataStore, question: Question, parentCategory: Category?) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
            isSet = true
        }
        
        func addAnswer() {
            withAnimation {
                store.addAnswer(at: question, with: newAnswerText)
                newAnswerText.clear()
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
