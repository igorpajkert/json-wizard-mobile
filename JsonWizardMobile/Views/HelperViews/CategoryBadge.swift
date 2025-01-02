//
//  CategoryBadge.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct CategoryBadge: View {
    
    var category: Category
    
    var color: Color {
        guard let color = category.color else { return Color.accentColor }
        return color
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(color)
            Text(category.title)
                .foregroundStyle(color.adaptedTextColor())
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
        }
        .fixedSize()
    }
}

#Preview("Red") {
    CategoryBadge(category: Question.sampleData[0].categories![0])
}

#Preview("Purple") {
    CategoryBadge(category: Question.sampleData[0].categories![1])
}

#Preview("Nil") {
    CategoryBadge(category: Question.sampleData[1].categories![0])
}
