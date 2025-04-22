//
//  DeveloperPreview.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import Foundation

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    public var cities: [City] = [
        .init(cityName: "Rome", country: .italy, state: nil, latitude: 41.902782, longitude: 12.496366),
        .init(cityName: "Los Angeles", country: .unitedStates, state: .california, latitude: 34.052235, longitude: -118.243683),
        .init(cityName: "Paris", country: .france, state: nil, latitude: 48.864716, longitude: 2.349014),
        .init(cityName: "Barcelona", country: .spain, state: nil, latitude: 41.390205, longitude: 2.154007),
        .init(cityName: "New York", country: .unitedStates, state: .newYork, latitude: 40.730610, longitude: -73.935242),
        .init(cityName: "Miami", country: .unitedStates, state: .florida, latitude: 25.761691, longitude: -80.191788),
        .init(cityName: "Sydney", country: .australia, state: nil, latitude: -33.8688, longitude: 151.2093),
        .init(cityName: "St.Moritz", country: .switzerland, state: nil, latitude: 46.490723, longitude: 9.835502),
        .init(cityName: "Manchester", country: .unitedKingdom, state: nil, latitude: 53.479382, longitude: -2.241934),
    ]
    
    public var listings: [Listing] = [] {
        didSet(value) {
            print("Adding")
        }
    }
}
