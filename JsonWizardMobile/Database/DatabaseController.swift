//
//  DatabaseController.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/01/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

/// A class responsible for managing interactions with the Firestore database.
final class DatabaseController {
    
    /// Loads data of a specified type from a document within a collection in Firestore.
    func getData<T>(from document: String, within collection: String) async throws -> T where T: Codable {
        let database = Firestore.firestore()
        let docRef = database.collection(collection).document(document)
        return try await docRef.getDocument(as: T.self)
    }
    
    func getAllDocuments<T>(from collection: String) async throws -> [T] where T: Codable {
        let database = Firestore.firestore()
        let querySnaphot = try await database.collection(collection).getDocuments()
        var documents: [T] = []
        for document in querySnaphot.documents {
            documents.append(try document.data(as: T.self))
        }
        return documents
    }
    
    /// Saves data of a specified type into a document within a collection in Firestore.
    func setData<T>(_ data: T, in document: String, within collection: String, merge: Bool) async throws -> Bool where T: Codable {
        return try await withCheckedThrowingContinuation { continuation in
            let database = Firestore.firestore()
            do {
                try database.collection(collection).document(document).setData(from: data, merge: merge) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: true)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func set<T: Codable>(_ data: T, in document: String, within collection: String, merge: Bool = true) throws {
        let db = Firestore.firestore()
        try db.collection(collection).document(document).setData(from: data, merge: merge)
    }
    
    /// Deletes a Firestore document from a specified collection.
    func delete(document: String, within collection: String) async throws {
        let database = Firestore.firestore()
        try await database.collection(collection).document(document).delete()
    }
}
