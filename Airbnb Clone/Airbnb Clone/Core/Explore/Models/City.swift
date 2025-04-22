//
//  City.swift
//  Airbnb Clone
//
//  Created by Luka on 19.3.25..
//

import Foundation

enum CountryName: String {
    case unitedStates = "United States"
    case unitedKingdom = "United Kingdom"
    case france = "France"
    case italy = "Italy"
    case spain = "Spain"
    case switzerland = "Switzerland"
    case australia = "Australia"
}

enum UsState: String {
    case alabama = "Alabama"
    case california = "California"
    case idaho = "Idaho"
    case indiana = "Indiana"
    case newYork = "New York"
    case massachussets = "Massachusetts"
    case oregon = "Oregon"
    case texas = "Texas"
    case florida = "Florida"
    case illinois = "Illinois"
    case maryland = "Maryland"
    case newJersey = "New Jersey"
    case arizona = "Arizona"
    case connecticut = "Connecticut"
    case washington = "Washington"
    case utah = "Utah"
    case georgia = "Georgia"
    case nevada = "Nevada"
    case colorado = "Colorado"
}

struct City: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let cityName: String
    let country: CountryName
    let state: UsState?
    let latitude: Double
    let longitude: Double
}
