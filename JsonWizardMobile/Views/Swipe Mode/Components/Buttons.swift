//
//  Buttons.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/03/2025.
//

import SwiftUI

// MARK: Toolbar
struct ToolbarButtonAdd: ToolbarContent {
    
    let disabled: Bool
    let action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("button_add") {
                action()
            }
            .disabled(disabled)
        }
    }
}

struct ToolbarButtonCancel: ToolbarContent {
    
    let action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("button_cancel") {
                action()
            }
        }
    }
}

// MARK: Keyboard
struct KeyboardButtonDone: ToolbarContent {
    
    var isFocused: Bool
    let action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            if isFocused {
                Spacer()
                Button("button_done") {
                    action()
                }
            }
        }
    }
}
