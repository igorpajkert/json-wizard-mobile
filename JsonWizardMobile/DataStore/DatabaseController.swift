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
    func loadData<T>(from document: String, within collection: String) async throws -> T where T: Codable {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(document)
        return try await docRef.getDocument(as: T.self)
    }
    
    /// Saves data of a specified type into a document within a collection in Firestore.
    /// - Parameters:
    ///   - data: The data to save. It must conform to `Codable`.
    ///   - document: The name of the Firestore document to write data to.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Throws: An error if the data cannot be encoded or saved to Firestore.
    /// - Note: This function encodes the provided data to a Firestore-compatible format.
    func saveData<T>(_ data: T, into document: String, within collection: String) async throws -> Bool where T: Codable {
        return try await withCheckedThrowingContinuation { continuation in
            let database = Firestore.firestore()
            do {
                try database.collection(collection).document(document).setData(from: data, merge: true) { error in
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
}
