//
//  SwipeModeView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 18/03/2025.
//

import SwiftUI

struct SwipeModeView: View {
    
    @State private var swipeMode = SwipeMode()
    
    var body: some View {
        SwipeQuestionsView(swipeMode: $swipeMode)
            .swipeMode(swipeMode)
    }
}

#Preview {
    SwipeModeView()
}
