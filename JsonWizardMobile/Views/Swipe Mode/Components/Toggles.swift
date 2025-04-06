//
//  Toggles.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/03/2025.
//

import SwiftUI

struct ToggleIsCorrect: View {
    
    @Binding var isOn: Bool
    
    private var labelTitle: LocalizedStringKey {
        isOn ? "text_true" : "text_false"
    }
    
    private var labelImage: String {
        isOn ? "checkmark.circle" : "xmark.circle"
    }
    
    private var labelColor: Color {
        isOn ? .green : .red
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Label(labelTitle, systemImage: labelImage)
                .foregroundStyle(labelColor)
                .contentTransition(.symbolEffect(.replace))
                .animation(.default, value: isOn)
        }
        .tint(.accent)
    }
}
