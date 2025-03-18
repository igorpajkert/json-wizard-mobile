//
//  SwipeButtonMigrate.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/03/2025.
//

import SwiftUI

struct SwipeButtonMigrate: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("button_migrate", systemImage: "arrow.left.arrow.right")
        }
        .tint(.orange)
    }
}
