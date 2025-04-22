//
//  NetworkManager.swift
//  Airbnb Clone
//
//  Created by Luka on 22.4.25..
//


import Foundation
import SwiftUI
import FirebaseFirestore

class NetworkManager<T:Codable> {
    static func decodeDocument(collectionPath: String, documentId: String) async throws -> T {
        let db = Firestore.firestore()
        do {
            let data = try await db.collection(collectionPath)
                .document(documentId)
                .getDocument(as: T.self)
            return data
        } catch let error {
            throw error
        }
    }
}
