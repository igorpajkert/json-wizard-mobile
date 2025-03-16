//
//  Chat.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 15/03/2025.
//

import SwiftUI
import FirebaseFirestore

@Observable
class Chat {
    
    private(set) var messages = [Message]()
    private(set) var lastMessageId = 0
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let orderByField = "timestamp"
    private let messagesCount = 15
    private let collection = "messages"
    
    init() {
        listener = attachMessagesListener()
    }
    
    deinit {
        removeMessagesListener()
    }
    
    private func attachMessagesListener() -> ListenerRegistration {
        return db.collection(collection)
            .order(by: orderByField, descending: true)
            .limit(to: messagesCount)
            .addSnapshotListener { querySnapshot, error in
                
                guard querySnapshot?.metadata.isFromCache == false else { return }
                
                querySnapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        if let newMessage = try? change.document.data(as: Message.self) {
                            self.messages.append(newMessage)
                        }
                    }
                }
                
                self.messages.sort { $0.timestamp < $1.timestamp }
                
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
            }
    }
    
    private func removeMessagesListener() {
        listener?.remove()
    }
    
    private func loadMoreMessages() {
        // Ensure there is at least one message to use as a cursor.
        guard let oldestMessage = messages.first else { return }
        
        db.collection(collection)
            .order(by: orderByField, descending: true)
            .start(after: [oldestMessage.timestamp])
            .limit(to: messagesCount)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading older messages: \(error)")
                    return
                }
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    // No more messages to load
                    return
                }
                // Convert the documents to Message objects
                var olderMessages = snapshot.documents.compactMap { try? $0.data(as: Message.self) }
                // Reverse the order since the query orders descending (newest first)
                olderMessages.reverse()
                // Filter out duplicates based on the message id
                let uniqueOlderMessages = olderMessages.filter { newMessage in
                    !self.messages.contains(where: { existingMessage in
                        existingMessage.id == newMessage.id
                    })
                }
                withAnimation {
                    self.messages.insert(contentsOf: uniqueOlderMessages, at: 0)
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
    
    func onRefresh() {
        loadMoreMessages()
    }
}
