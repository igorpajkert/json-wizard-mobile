//
//  CategoryStatusBadge.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct CategoryStatusBadge: View {
    
    var category: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(category.status.mainColor, lineWidth: 2)
            Text(category.status.name)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
        }
        .font(.callout)
        .fixedSize()
    }
}

#Preview {
    CategoryStatusBadge(category: Category.sampleData[0])
}
