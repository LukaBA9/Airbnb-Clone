//
//  Review.swift
//  Airbnb Clone
//
//  Created by Luka on 1.4.25..
//

import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let cleanliness: Int, check_in: Int, location: Int, value: Int
    let description: String
    let userId: String
    
    var stars: Int {
        return Int((cleanliness + check_in + location + value) / 4)
    }
}
