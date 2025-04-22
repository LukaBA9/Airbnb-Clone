//
//  ReserveView.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import SwiftUI

struct ReserveView: View {
    
    enum SheetConfig: Int, Identifiable {
        case dates
        case guests
        
        var id: Int { self.rawValue }
    }
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    @State private var reserved: Bool = false
    
    @State private var sheetConfig: SheetConfig? = nil
    
    let listing: Listing
    var body: some View {
        if !reserved {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 12) {
                        Image(listing.imageURLs.first ?? "No images")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(listing.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(ListingType(rawValue: listing.type)!.title)
                            }
                            
                            Spacer()
                            StarRatingView(rating: listing.rating)
                        }
                        Spacer()
                    }
                    .frame(height: 140)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 27) {
                        Text("Your trip")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Dates")
                                Text(exploreViewModel.dateRangeDescription)
                            }
                            Spacer()
                            Button {
                                //show sheet
                                sheetConfig = .dates
                            } label: {
                                Text("Edit")
                                    .foregroundStyle(.black)
                                    .underline()
                            }
                            
                        }
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Guests")
                                HStack(spacing: 0) {
                                    Text(exploreViewModel.numberOfGuests() > 0 ? "\(exploreViewModel.numberOfGuests()) " : "No ")
                                    Text(exploreViewModel.numberOfGuests() == 1 ? "guest" : "guests")
                                }
                            }
                            Spacer()
                            Button {
                                //show sheet
                                sheetConfig = .guests
                            } label: {
                                Text("Edit")
                                    .foregroundStyle(.black)
                                    .underline()
                            }
                            
                        }
                        
                    }
                    Divider()
                    
                    //price details
                    
                    VStack(alignment: .leading, spacing: 27) {
                        Text("Price details")
                            .font(.title2)
                            .fontWeight(.semibold)
                        VStack(spacing: 18) {
                            HStack(spacing: 0) {
                                Text("$\(listing.pricePerNight.formattedDesription) x \(exploreViewModel.selectedDateInterval.formattedDesription) \(exploreViewModel.selectedDateInterval == 1 ? "night" : "nights")")
                                Spacer()
                                Text("$\(exploreViewModel.totalPrice().formattedDesription)")
                            }
                            HStack {
                                Text("Airbnb service fee")
                                Spacer()
                                Text("$107.98")
                            }
                        }
                    }
                    Divider()
                    HStack(alignment: .top) {
                        Text("Total")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        VStack (alignment: .trailing, spacing: 18) {
                            Text("$\((exploreViewModel.totalPrice() + 107.98).formattedDesription)")
                                .fontWeight(.semibold)
                        }
                    }
                    Divider()
                    
                    //login screen
                    if !mainViewModel.isSignedIn {
                        LogInFormView() {
                            Text("Log in or sign up to book")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    else {
                        PayFormView(listing: listing, reserved: $reserved, totalPrice: exploreViewModel.totalPrice() + 107.98)
                    }
                    Spacer()
                }
                .padding()
            }
            .sheet(item: $sheetConfig) { item in
                switch item {
                case .dates:
                    CalendarPicker(checkInDate: $exploreViewModel.startDate, checkOutDate: $exploreViewModel.endDate).presentationDetents([.medium])
                case .guests:
                    GuestSelectionView(temporarySearchFilter: $exploreViewModel.guests)
                        .padding()
                        .presentationDetents([.medium])
                }
            }
        }
        else {
            SuccessfulReservationView()
        }
    }
}

#Preview {
    ReserveView(listing: DeveloperPreview.shared.listings.first!)
}
