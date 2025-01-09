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
    
    /// Initializes the `DatabaseController` and configures the Firebase app.
    /// This ensures that Firebase services are ready to use throughout the app.
    init() {
        FirebaseApp.configure()
    }
    
    /// Loads data of a specified type from a document within a collection in Firestore.
    /// - Parameters:
    ///   - document: The name of the Firestore document to fetch.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Returns: The decoded data of the specified type `DataToLoad`.
    /// - Throws: An error if the document cannot be fetched or decoded.
    /// - Note: This function requires the data model to conform to `Codable`.
    func loadData<DataToLoad>(from document: String, within collection: String) async throws -> DataToLoad where DataToLoad: Codable {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(document)
        return try await docRef.getDocument(as: DataToLoad.self)
    }
    
    /// Saves data of a specified type into a document within a collection in Firestore.
    /// - Parameters:
    ///   - data: The data to save. It must conform to `Codable`.
    ///   - document: The name of the Firestore document to write data to.
    ///   - collection: The name of the Firestore collection containing the document.
    /// - Throws: An error if the data cannot be encoded or saved to Firestore.
    /// - Note: This function encodes the provided data to a Firestore-compatible format.
    func saveData<DataToSave>(_ data: DataToSave, into document: String, within collection: String) throws where DataToSave: Codable {
        let database = Firestore.firestore()
        try database.collection(collection).document(document).setData(from: data)
    }
}
