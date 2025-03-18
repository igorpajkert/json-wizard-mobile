//
//  CategoryCardView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryCardView: View {
    
    @Environment(\.store) private var store
    
    var category: Category
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                CategoryBadge(category: category)
                    .font(.title)
            }
            .scrollIndicators(.never)
            Text(category.subtitle ?? "Subtitle")
                .font(.subheadline)
            Spacer()
            countAndBadge
            if category.productionTransferDate != nil &&
                store.currentCollectionType != .production {
                CategoryProductionBadge()
            }
        }
        .padding(.vertical)
    }
    
    private var countAndBadge: some View {
        HStack {
            Label("\(category.questionsCount) questions_count", systemImage: "rectangle.stack")
                .font(.callout)
            Spacer()
            CategoryStatusBadge(category: category)
        }
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 120)) {
    CategoryCardView(category: Category.sampleData[4])
}

struct CategoryProductionBadge: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.red)
            Text("text_is_in_production")
                .foregroundStyle(.red.adaptedTextColor())
                .font(.caption)
                .bold()
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, maxHeight: 20)
        .shadow(radius: 2)
    }
}
