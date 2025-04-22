//
//  Trip.swift
//  Airbnb Clone
//
//  Created by Luka on 31.3.25..
//

import Foundation

struct Trip: Identifiable, Codable {
    let id: String
    let listingId: String
    let wayToPay: String
}
