//
//  SwipeModeCollectionPicker.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 25/03/2025.
//

import SwiftUI

struct SwipeModeCollectionPicker: View {
    
    @Environment(\.swipeMode) private var swipeMode
    
    @Binding var selection: SwipeMode.CollectionType
    
    var body: some View {
        VStack {
            Picker("picker_collection", selection: $selection) {
                ForEach(SwipeMode.CollectionType.allCases) { type in
                    Text(type.name)
                        .tag(type as SwipeMode.CollectionType)
                }
            }
            .pickerStyle(.segmented)
            HStack {
                Label("label_questions_count", systemImage: "square.stack")
                Spacer()
                Text(swipeMode.questions.count, format: .number)
            }
        }
    }
}

#Preview(traits: .fixedLayout(width: 600, height: 200)) {
    SwipeModeCollectionPicker(selection: .constant(.development))
}
