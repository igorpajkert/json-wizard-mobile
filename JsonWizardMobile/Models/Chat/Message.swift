//
//  Message.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable, Equatable {
    let id: Int
    var text: String
    let senderId: String
    let senderName: String
    var timestamp: Date
    
    init(
        id: Int = Int.randomID(),
        text: String,
        senderId: String,
        senderName: String,
        timestamp: Date
    ) {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = timestamp
    }
}
