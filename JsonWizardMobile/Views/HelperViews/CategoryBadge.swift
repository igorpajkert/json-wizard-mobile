//
//  CategoryBadge.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct CategoryBadge: View {
    
    var category: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(category.unwrappedColor)
            Text(category.title)
                .foregroundStyle(category.unwrappedColor.adaptedTextColor())
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
        }
        .fixedSize()
    }
}

#Preview("Red") {
    CategoryBadge(category: .init(id: 0, title: "Red", color: .red))
}

#Preview("Purple") {
    CategoryBadge(category: .init(id: 1, title: "Purple", color: .purple))
}
