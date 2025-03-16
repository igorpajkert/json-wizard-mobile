//
//  SwipeButtonDelete.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 01/03/2025.
//

import SwiftUI

struct SwipeButtonDelete: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(role: .destructive, action: action) {
            Label("button_delete", systemImage: "trash.fill")
        }
    }
}
