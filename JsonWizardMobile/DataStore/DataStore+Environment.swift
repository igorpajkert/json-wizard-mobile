//
//  DataStore+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/01/2025.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var store = DataStore()
}

extension View {
    func dataStore(_ store: DataStore) -> some View {
        environment(\.store, store)
    }
}
