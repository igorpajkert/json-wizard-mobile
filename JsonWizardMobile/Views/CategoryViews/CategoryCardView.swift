//
//  CategoryCardView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryCardView: View {
    
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
    CategoryCardView(category: Category.sampleData[0])
}
