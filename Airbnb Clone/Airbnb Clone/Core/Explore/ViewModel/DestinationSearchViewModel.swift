//
//  DestinationSearchViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 23.4.25..
//

import Foundation

class DestinationSearchViewModel: ObservableObject {
    enum DestinationSearchOptions: Int, CaseIterable {
        case location
        case dates
        case guests
        
        var id : Int {
            rawValue
        }
    }
    
    @Published var destinationText: String = ""
    @Published var selectedOption: DestinationSearchOptions = .location
    
    @Published var temporarySearchFilter: (location: City?, checkInDate: Date?, checkOutDate: Date?, guests: (adults: Int, children: Int, infants: Int, pets: Int)) = (nil, nil, nil, (0, 0, 0, 0))
    
    public var suggestedDestinations: [City] {
        DeveloperPreview.shared.cities.filter { city in
            city.country == .unitedStates
        }
    }
    
    public var filteredSearchSuggestions: [City] {
        DeveloperPreview.shared.cities.filter { city in
            (city.cityName.lowercased().contains(destinationText.lowercased()) || city.country.rawValue.lowercased().contains(destinationText.lowercased()))
        }
    }
    
    public var numberOfGuests: Int {
        return temporarySearchFilter.guests.adults + temporarySearchFilter.guests.children + temporarySearchFilter.guests.pets + temporarySearchFilter.guests.infants
    }
    
    public func assignTemporarySearchFilter(location: City?, checkInDate: Date?, checkOutDate: Date?, guests: (adults: Int, children: Int, infants: Int, pets: Int)) {
        temporarySearchFilter.location = location
        temporarySearchFilter.checkInDate = checkInDate
        temporarySearchFilter.checkOutDate = checkOutDate
        temporarySearchFilter.guests = guests
    }
    
    public func showExploreView(updateSearchFilters: (_ location: City?, _ checkInDate: Date, _ checkOutDate: Date, _ guests: (adults: Int, children: Int, infants: Int, pets: Int)) -> Void, updateCameraPosition: (_ latitude: Double, _ longitude: Double) -> Void, fetchListings: () -> Void, show: () -> Void, updateSelectedOption: () -> Void) {
        if selectedOption.id % (DestinationSearchOptions.allCases.count - 1) == 0 {
            guard let checkInDate = temporarySearchFilter.checkInDate, let checkOutDate = temporarySearchFilter.checkOutDate else { return }
            let city = temporarySearchFilter.location
            let longitude = city?.longitude ?? 0.0
            let latitude = city?.latitude ?? 0.0
            
            updateSearchFilters(temporarySearchFilter.location, checkInDate, checkOutDate, temporarySearchFilter.guests)
            updateCameraPosition(latitude, longitude)
            show()
            fetchListings()
        } else {
            updateSelectedOption()
        }
    }
}
