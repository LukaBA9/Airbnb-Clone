//
//  Global.swift
//  Airbnb Clone
//
//  Created by Luka on 25.3.25..
//

import Foundation
import FirebaseFirestore

class Global {
    static let main: Global = .init()
    public var currentUser: User? = nil {
        didSet {
            updateUserData()
        }
    }
    public var today: (year: Int, month: Int, day: Int) = (
        year: Calendar.current.component(.year, from: Date()),
        month: Calendar.current.component(.month, from: Date()),
        day: Calendar.current.component(.day, from: Date())
    )
    
    public func updateUserData() {
        guard let currentUser = Global.main.currentUser else {
            return
        }
        Task {
            do {
                try await Firestore.firestore().collection("users").document(currentUser.id).setData(currentUser.asDictionary())
            } catch {
                return
            }
        }
    }
    
    public func getMonthName(from month: Int) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM"
        
        let date = Calendar.current.date(from: DateComponents(year: 2025, month: month, day: 01))
        
        if let date = date {
            return formatter.string(from: date)
        }
        
        return ""
    }
}
