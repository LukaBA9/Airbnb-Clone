//
//  Extensions.swift
//  Airbnb Clone
//
//  Created by Luka on 24.3.25..
//

import Foundation
import SwiftUI
import FirebaseFirestore

extension Sheet {
    mutating func hide(_ condition: Bool, value: CGFloat) {
        if condition {
            offset += value
        }
    }
}

extension Encodable {
    func asDictionary() -> [String : Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension [Review] {
    mutating func average() -> Double {
        var sum: Double = 0
        for element in self {
            sum += Double(element.stars)
        }
        return (sum / Double(self.count))
    }
}

//struct Decode<T: Decodable> {
//    static func decodeDocument(collectionPath: String, documentId: String) async throws -> T {
//        let db = Firestore.firestore()
//        do {
//            let data = try await db.collection(collectionPath)
//                .document(documentId)
//                .getDocument(as: T.self)
//            return data
//        } catch let error {
//            throw error
//        }
//    }
//}



extension Double {
    var formattedDesription: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number) ?? ""
        return formattedValue
    }
}
