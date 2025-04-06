//
//  JsonWizardMobileApp.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import SwiftUI
import FirebaseCore

@main
struct JsonWizardMobileApp: App {
    
    @State private var store: DataStore
    @State private var swipeMode = SwipeMode()
    
    init() {
        FirebaseApp.configure()
        store = DataStore()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .dataStore(store)
                .swipeMode(swipeMode)
        }
    }
}
