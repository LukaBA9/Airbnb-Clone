//
//  User.swift
//  Airbnb Clone
//
//  Created by Luka on 28.3.25..
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    
    let id: String
    let name: String
    let email: String
    
    var wishlist: [String] = []
    
    //listing ids
    var trips: [String] = []
}
