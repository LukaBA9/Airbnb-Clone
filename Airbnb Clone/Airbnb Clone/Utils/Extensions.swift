//
//  Extensions.swift
//  Airbnb Clone
//
//  Created by Luka on 24.3.25..
//

import Foundation
import SwiftUI
import FirebaseFirestore

extension Date {
    func smallerThan(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        return calendar.date(from: nowComponents)!.timeIntervalSince1970 <= date.timeIntervalSince1970
    }
}

extension CustomSheet {
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
