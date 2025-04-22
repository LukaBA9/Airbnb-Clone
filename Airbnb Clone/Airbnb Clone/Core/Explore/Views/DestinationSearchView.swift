//
//  DestinationSearchView.swift
//  Airbnb Clone
//
//  Created by Luka on 17.3.25..
//

import SwiftUI
import UIKit
import HorizonCalendar

struct DestinationSearchView: View {
    enum DestinationSearchOptions: Int, CaseIterable {
        case location
        case dates
        case guests
        
        var id : Int {
            rawValue
        }
    }
    
    @Binding var show: Bool
    @State private var destinationText: String = ""
    @State private var selectedOption: DestinationSearchOptions = .location
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    @State private var temporarySearchFilter: (location: City?, checkInDate: Date?, checkOutDate: Date?, guests: (adults: Int, children: Int, infants: Int, pets: Int)) = (nil, nil, nil, (0, 0, 0, 0))
    
    var filteredSearchSuggestions: [City] {
        DeveloperPreview.shared.cities.filter { city in
            (city.cityName.lowercased().contains(destinationText.lowercased()) || city.country.rawValue.lowercased().contains(destinationText.lowercased()))
        }
    }
    
    var suggestedDestinations: [City] {
        DeveloperPreview.shared.cities.filter { city in
            city.country == .unitedStates
        }
    }
    
    var numberOfGuests: Int {
        return temporarySearchFilter.guests.adults + temporarySearchFilter.guests.children + temporarySearchFilter.guests.pets + temporarySearchFilter.guests.infants
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if !isFocused {
                    if exploreViewModel.location != nil {
                        xButton
                    }
                }
                else {
                    backButton
                }
                Spacer()
                
                if !destinationText.isEmpty {
                    clearButton
                }
            }
            .padding()
            
            locationPicker
            .modifier(CollapsableDestinationViewModifier())
            .padding(.horizontal, isFocused ? 0 : 12)
            .padding(.bottom, isFocused ? -350 : 12)
            .onTapGesture {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedOption = .location
                }
            }
            .frame(height: selectedOption == .location ? 400 : 81)
            
            datesPicker
            .zIndex(-1)
            .modifier(CollapsableDestinationViewModifier())
            .padding()
            .onTapGesture {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedOption = .dates
                }
            }
            .frame(height: selectedOption == .dates ? 400 : 81)
            
            guestPicker
            .zIndex(-1)
            .modifier(CollapsableDestinationViewModifier())
            .padding()
            .onTapGesture {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedOption = .guests
                }
            }
            .frame(height: selectedOption == .guests ? 400 : 81)
            //Clear all-reset-skip - Search-Next buttons
            Spacer()
            HStack {
                clearAllButton

                Spacer()
                
                searchButton
            }
            .zIndex(-1)
            .padding()
        }
        .onAppear() {
            temporarySearchFilter.location = exploreViewModel.location
            temporarySearchFilter.checkInDate = exploreViewModel.startDate
            temporarySearchFilter.checkOutDate = exploreViewModel.endDate
            temporarySearchFilter.guests = exploreViewModel.guests
        }
        .animation(.snappy(duration: 0.3), value: isFocused)
    }
    
    private func showExploreView() {
        if selectedOption.id % (DestinationSearchOptions.allCases.count - 1) == 0 {
            exploreViewModel.location = temporarySearchFilter.location
            exploreViewModel.guests = temporarySearchFilter.guests
            let city = temporarySearchFilter.location
            let longitude = city?.longitude ?? 0.0
            let latitude = city?.latitude ?? 0.0
            exploreViewModel.cameraPosition = .region(.init(center: .init(latitude: latitude, longitude: longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
            withAnimation(.snappy(duration: 0.3)) { show.toggle() }
            guard let checkInDate = temporarySearchFilter.checkInDate, let checkOutDate = temporarySearchFilter.checkOutDate else { return }
            exploreViewModel.startDate = checkInDate
            exploreViewModel.endDate = checkOutDate
            exploreViewModel.fetchListings()
        } else {
            withAnimation(.snappy(duration: 0.3)) { selectedOption = DestinationSearchOptions(rawValue: selectedOption.id + 1)! }
        }
    }
    
    private var xButton: some View {
        Button {
            withAnimation(.snappy(duration: 0.3)) {
                show.toggle()
            }
        } label: {
            Image(systemName: "xmark.circle")
                .imageScale(.large)
                .foregroundStyle(.black)
        }
    }
    
    private var backButton: some View {
        Button {
            withAnimation(.snappy) {
                destinationText = ""
                isFocused = false
            }
        } label: {
            Image(systemName: "arrow.backward.circle")
                .imageScale(.large)
                .foregroundStyle(.black)
        }
    }
    
    private var clearButton: some View {
        Button {
            destinationText = ""
        } label: {
            Text("Clear")
                .foregroundStyle(.black)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    private var locationPicker: some View {
        VStack(alignment: .leading, spacing: 24) {
            if selectedOption == .location {
                if !isFocused {
                    Text("Where to?")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                // MARK - where to search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.small)
                    
                    TextField("Search destinations", text: $destinationText)
                        .font(.subheadline)
                        .focused($isFocused)
                }
                .frame(height: 44)
                .padding(.horizontal)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color(.systemGray4))
                }
                
                //Search suggestions
                ScrollView (showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(destinationText.isEmpty ? suggestedDestinations : filteredSearchSuggestions) { city in
                            CitySearchResultView(city: city, action: {
                                temporarySearchFilter.location = city
                                withAnimation(.snappy(duration: 0.3)) { selectedOption = .dates }
                                isFocused = false
                            })
                        }
                    }
                }
            } else {
                CollapsedPickerView(title: "Where", description: temporarySearchFilter.location == nil ? "Add destination" : "\(temporarySearchFilter.location!.cityName)\(temporarySearchFilter.location!.state != nil ? ", \(temporarySearchFilter.location!.state?.rawValue ?? "")" : ""), \(temporarySearchFilter.location!.country.rawValue)")
            }
        }
    }
    
    private var datesPicker: some View {
        VStack(alignment: .leading) {
            if selectedOption == .dates {
                Text("When's your trip?")
                    .font(.title2)
                    .fontWeight(.semibold)
                //Calendar
                CalendarPicker(checkInDate: $temporarySearchFilter.checkInDate, checkOutDate: $temporarySearchFilter.checkOutDate)
            } else {
                CollapsedPickerView(title: "When", description: temporarySearchFilter.checkInDate == nil || temporarySearchFilter.checkOutDate == nil ? "Add dates" : exploreViewModel.dateRangeDescription)
            }
        }
    }
    
    private var guestPicker: some View {
        VStack(alignment: .leading) {
            if selectedOption == .guests {
                GuestSelectionView(temporarySearchFilter: $temporarySearchFilter.guests)

            } else {
                CollapsedPickerView(title: "Who", description: numberOfGuests == 0 ? "Add guests" : "\(numberOfGuests) \(numberOfGuests == 1 ? "guest" : "guests")")
            }
        }
    }
    
    private var clearAllButton: some View {
        Button {
            //
        } label: {
            Text("Clear all")
                .foregroundStyle(.black)
                .underline()
        }
    }
    
    private var searchButton: some View {
        Button {
            showExploreView()
        } label: {
            HStack {
                if selectedOption.id == 0 || selectedOption.id == DestinationSearchOptions.allCases.count - 1 {
                    Image(systemName: "magnifyingglass")
                }
                Text(selectedOption.id == 0 || selectedOption.id == DestinationSearchOptions.allCases.count - 1 ? "Search" : "Next")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(width: 132, height: 55)
            .background(selectedOption.id != 0 && selectedOption.id != DestinationSearchOptions.allCases.count - 1 ? .black : temporarySearchFilter.location == nil ? .pink.opacity(0.5) : .pink, in: RoundedRectangle(cornerRadius: 6))
        }
        .disabled(temporarySearchFilter.location == nil && (selectedOption.id == 0 || selectedOption.id == DestinationSearchOptions.allCases.count - 1))
    }
}

struct CollapsableDestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View
    {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
    }
}



#Preview {
    MainTabView()
        .environmentObject(ExploreViewModel())
}
