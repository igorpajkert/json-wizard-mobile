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
    /// - Parameters:
    ///   - document: The name of the Firestore document to fetch.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Returns: The decoded data of the specified type `T`.
    /// - Throws: An error if the document cannot be fetched or decoded.
    /// - Note: This function requires the data model to conform to `Codable`.
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
    /// - Parameters:
    ///   - data: The data to save. It must conform to `Codable`.
    ///   - document: The name of the Firestore document to write data to.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Throws: An error if the data cannot be encoded or saved to Firestore.
    /// - Note: This function encodes the provided data to a Firestore-compatible format.
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
    
    /// Deletes a Firestore document from a specified collection.
    /// - Parameters:
    ///   - document: The identifier of the document to delete.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Throws: An error if the deletion operation fails.
    /// - Note: This operation permanently removes the document from Firestore.
    func delete(document: String, within collection: String) async throws {
        let database = Firestore.firestore()
        try await database.collection(collection).document(document).delete()
    }
}
