//
//  SwipeQuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 25/03/2025.
//

import SwiftUI

struct SwipeQuestionEditView: View {
    
    let question: SwipeQuestion
    
    var body: some View {
        Text(question.text)
    }
}

#Preview {
    SwipeQuestionEditView(question: .init(text: "Test"))
}
