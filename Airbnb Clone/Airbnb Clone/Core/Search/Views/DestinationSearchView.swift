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
    
    @Binding var show: Bool
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    @StateObject var viewModel: DestinationSearchViewModel = .init()
    
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
                
                if !viewModel.destinationText.isEmpty {
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
                    viewModel.selectedOption = .location
                }
            }
            .frame(height: viewModel.selectedOption == .location ? 400 : 81)
            
            datesPicker
            .zIndex(-1)
            .modifier(CollapsableDestinationViewModifier())
            .padding()
            .onTapGesture {
                withAnimation(.snappy(duration: 0.3)) {
                    viewModel.selectedOption = .dates
                }
            }
            .frame(height: viewModel.selectedOption == .dates ? 400 : 81)
            
            guestPicker
            .zIndex(-1)
            .modifier(CollapsableDestinationViewModifier())
            .padding()
            .onTapGesture {
                withAnimation(.snappy(duration: 0.3)) {
                    viewModel.selectedOption = .guests
                }
            }
            .frame(height: viewModel.selectedOption == .guests ? 400 : 81)
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
            viewModel.assignTemporarySearchFilter(location: exploreViewModel.location, checkInDate: exploreViewModel.startDate, checkOutDate: exploreViewModel.endDate, guests: exploreViewModel.guests)
        }
        .animation(.snappy(duration: 0.3), value: isFocused)
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
                viewModel.destinationText = ""
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
            viewModel.destinationText = ""
        } label: {
            Text("Clear")
                .foregroundStyle(.black)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    private var locationPicker: some View {
        VStack(alignment: .leading, spacing: 24) {
            if viewModel.selectedOption == .location {
                if !isFocused {
                    Text("Where to?")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                // MARK - where to search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.small)
                    
                    TextField("Search destinations", text: $viewModel.destinationText)
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
                        ForEach(viewModel.destinationText.isEmpty ? viewModel.suggestedDestinations : viewModel.filteredSearchSuggestions) { city in
                            CitySearchResultView(city: city, action: {
                                viewModel.temporarySearchFilter.location = city
                                withAnimation(.snappy(duration: 0.3)) { viewModel.selectedOption = .dates }
                                isFocused = false
                            })
                        }
                    }
                }
            } else {
                CollapsedPickerView(title: "Where", description: viewModel.temporarySearchFilter.location == nil ? "Add destination" : "\(viewModel.temporarySearchFilter.location!.cityName)\(viewModel.temporarySearchFilter.location!.state != nil ? ", \(viewModel.temporarySearchFilter.location!.state?.rawValue ?? "")" : ""), \(viewModel.temporarySearchFilter.location!.country.rawValue)")
            }
        }
    }
    
    private var datesPicker: some View {
        VStack(alignment: .leading) {
            if viewModel.selectedOption == .dates {
                Text("When's your trip?")
                    .font(.title2)
                    .fontWeight(.semibold)
                //Calendar
                CalendarPicker(checkInDate: $viewModel.temporarySearchFilter.checkInDate, checkOutDate: $viewModel.temporarySearchFilter.checkOutDate)
            } else {
                CollapsedPickerView(title: "When", description: viewModel.temporarySearchFilter.checkInDate == nil || viewModel.temporarySearchFilter.checkOutDate == nil ? "Add dates" : exploreViewModel.dateRangeDescription)
            }
        }
    }
    
    private var guestPicker: some View {
        VStack(alignment: .leading) {
            if viewModel.selectedOption == .guests {
                GuestSelectionView(temporarySearchFilter: $viewModel.temporarySearchFilter.guests)

            } else {
                CollapsedPickerView(title: "Who", description: viewModel.numberOfGuests == 0 ? "Add guests" : "\(viewModel.numberOfGuests) \(viewModel.numberOfGuests == 1 ? "guest" : "guests")")
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
            viewModel.showExploreView { location, checkInDate, checkOutDate, guests in
                exploreViewModel.updateSearchFilters(location: location, checkInDate: checkInDate, checkOutDate: checkOutDate, guests: guests)
            } updateCameraPosition: { latitude, longitude in
                exploreViewModel.updateCameraPosition(latitude: latitude, longitude: longitude)
            } fetchListings: {
                exploreViewModel.fetchListings()
            } show: {
                withAnimation(.snappy(duration: 0.3)) { show.toggle() }
            } updateSelectedOption: {
                withAnimation(.snappy(duration: 0.3)) { viewModel.selectedOption = DestinationSearchViewModel.DestinationSearchOptions(rawValue: viewModel.selectedOption.id + 1)! }
            }
        } label: {
            HStack {
                if viewModel.selectedOption.id == 0 || viewModel.selectedOption.id == DestinationSearchViewModel.DestinationSearchOptions.allCases.count - 1 {
                    Image(systemName: "magnifyingglass")
                }
                Text(viewModel.selectedOption.id == 0 || viewModel.selectedOption.id == DestinationSearchViewModel.DestinationSearchOptions.allCases.count - 1 ? "Search" : "Next")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(width: 132, height: 55)
            .background(viewModel.selectedOption.id != 0 && viewModel.selectedOption.id != DestinationSearchViewModel.DestinationSearchOptions.allCases.count - 1 ? .black : viewModel.temporarySearchFilter.location == nil ? .pink.opacity(0.5) : .pink, in: RoundedRectangle(cornerRadius: 6))
        }
        .disabled(viewModel.temporarySearchFilter.location == nil && (viewModel.selectedOption.id == 0 || viewModel.selectedOption.id == DestinationSearchViewModel.DestinationSearchOptions.allCases.count - 1))
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
