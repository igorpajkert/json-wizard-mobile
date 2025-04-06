//
//  SwipeMode+Fetch.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/04/2025.
//

import Foundation

extension SwipeMode {
    
    func fetchData() async {
        setCollection()
        
        do {
            if let currentCollection = currentCollection {
                let db = DatabaseController()
                questions = try await db.getAllDocuments(from: currentCollection.rawValue)
                attachListener(to: currentCollection)
            }
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: "guidance_swipe_mode_fetch_error",
                isDismissable: true
            )
        }
    }
}
