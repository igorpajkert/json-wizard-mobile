//
//  Chat.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class Chat {
    
    private(set) var messages = [Message]()
    private(set) var lastMessageId = 0
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let collection = "messages"
    
    init() {
        listener = attachMessagesListener()
    }
    
    deinit {
        listener?.remove()
    }
    
    private func attachMessagesListener() -> ListenerRegistration {
        return db.collection(collection).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
            
            self.messages.sort { $0.timestamp < $1.timestamp }
            
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    func sendMessage(with text: String) {
        do {
            guard let userId = Authentication.shared.user?.uid else { return }
            guard let userName = Authentication.shared.userData?.name else { return }
            
            let message = Message(
                text: text,
                senderId: userId,
                senderName: userName,
                timestamp: .now
            )
            
            try db.collection(collection).document().setData(from: message)
            
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    func showSender(for message: Message) -> Bool {
        guard let index = messages.firstIndex(of: message), index > messages.startIndex else {
            return false
        }
        
        guard let userId = Authentication.shared.user?.uid else {
            return false
        }
        
        guard userId != message.senderId else {
            return false
        }
        
        return messages[messages.index(before: index)].senderId != message.senderId
    }
}
