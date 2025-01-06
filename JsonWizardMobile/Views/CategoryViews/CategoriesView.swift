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
            ForEach(store.categories) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    CategoryCardView(category: category)                        
                }
            }
        }
        .listRowSpacing(10)
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
            .environment(\.store, DataStore(categories: Category.sampleData))
    }
}
