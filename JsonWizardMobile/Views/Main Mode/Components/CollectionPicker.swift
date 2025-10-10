//
//  CollectionPicker.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 21/02/2025.
//

import SwiftUI

struct CollectionPicker: View {
    
    @Environment(\.store) private var store
    
    @Binding var selection: DataStore.CollectionType
    
    var body: some View {
        VStack {
            Picker("picker_collection", selection: $selection) {
                ForEach(DataStore.CollectionType.allCases) { type in
                    Text(type.rawValue)
                        .tag(type as DataStore.CollectionType)
                }
            }
            .pickerStyle(.segmented)
            HStack {
                Label("label_categories_count", systemImage: "square.stack.3d.up")
                Spacer()
                Text(String(store.categories.count))
            }
            .padding(.vertical)
            HStack {
                Label("label_questions_count", systemImage: "rectangle.stack")
                Spacer()
                Text(String(store.questions.count))
            }            
        }
    }
}

#Preview {
    CollectionPicker(selection: .constant(.development))
}
