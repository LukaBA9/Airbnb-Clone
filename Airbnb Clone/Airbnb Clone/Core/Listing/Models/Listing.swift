//
//  Listing.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import Foundation
import FirebaseFirestore

struct Listing: Identifiable, Codable, Hashable {
    let id: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let numberOfBedrooms: Int
    let numberOfBathrooms: Int
    let numberOfBeds: Int
    let numberOfGuests: Int
    
    let bookedDates: [TimeInterval]
    
    var pricePerNight: Double
    let latitude: Double
    let longitude: Double
    
    var imageURLs: [String]
    
    let address: String
    let city: String
    let state: String
    
    let title: String
    var rating: Double
    
    var reviews: [String]
    
    var features: [Int]
    var amenities: [Int]
    
    let type: Int
    
    var bookedDatesFromToday: [TimeInterval] {
        var dates: [TimeInterval] = []
        let currDate = Date().timeIntervalSince1970
        for date in self.bookedDates {
            if currDate < date {
                dates.append(date)
            }
        }
        return dates
    }
}

enum ListingFeatures: Int, Codable, Identifiable, Hashable {
    case selfCheckIn
    case superHost
    
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .selfCheckIn: "Self check-in"
        case .superHost: "Superhost"
        }
    }
    
    var imageName: String {
        switch self {
        case .selfCheckIn: "door.left.hand.open"
        case .superHost: "medal"
        }
    }
    
    var subtitle: String {
        switch self {
        case .selfCheckIn:
            return "Check yourself in with the keypad."
        case .superHost:
            return "Superhosts are experienced, highly rated hosts who are commited to providing great stars for guests."
        }
    }
}

enum ListingAmenity: Int, Codable, Identifiable, Hashable {
    case parking
    case laundry
    case kitchen
    case firePit
    case tv
    case wifi
    case pool
    case alarmSystem
    case balcony
    
    var title: String {
        switch self {
        case .pool: "Pool"
        case .kitchen: "Kitchen"
        case .balcony: "Balcony"
        case .alarmSystem: "Alarm system"
        case .firePit: "Fire pit"
        case .tv: "TV"
        case .laundry: "Laundry"
        case .wifi: "Wi-Fi"
        case .parking: "Parking"
        }
    }
    
    var imageName: String {
        switch self {
        case .pool: "figure.pool.swim"
        case .kitchen: "fork.knife"
        case .balcony: "building"
        case .alarmSystem: "checkerboard.shield"
        case .firePit: "fireplace"
        case .tv: "tv"
        case .laundry: "washer"
        case .wifi: "wifi"
        case .parking: "car"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum ListingType: Int, Codable, Identifiable, Hashable {
    case apartment
    case house
    case villa
    case hotel
    
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .apartment: "Apartment"
        case .hotel: "Hotel"
        case .house: "House"
        case .villa: "Villa"
        }
    }
}
