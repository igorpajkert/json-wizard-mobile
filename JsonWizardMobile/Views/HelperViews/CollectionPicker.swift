//
//  CollectionPicker.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 21/02/2025.
//

import SwiftUI

struct CollectionPicker: View {
    
    @Binding var selection: DataStore.CollectionType
    
    var body: some View {
        Picker("picker_collection", selection: $selection) {
            ForEach(DataStore.CollectionType.allCases) { type in
                Text(type.rawValue)
                    .tag(type as DataStore.CollectionType)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    CollectionPicker(selection: .constant(.development))
}
