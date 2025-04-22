//
//  ListingItemView.swift
//  Airbnb Clone
//
//  Created by Luka on 16.3.25..
//

import SwiftUI

struct ListingItemView: View {
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    let listing: Listing
    var body: some View {
        VStack(spacing: 8) {
            // images
            ListingImageCarouselView(listing: listing)
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .topTrailing) {
                SaveButton(listing: listing)
                    .padding()
            }
            
            // listing details
            HStack(alignment: .top) {
                //details
                VStack(alignment: .leading) {
                    Text("\(listing.city), \(listing.state)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Text(exploreViewModel.dateRangeDescription)
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 4) {
                        Text("$\(listing.pricePerNight.formattedDesription)")
                            .fontWeight(.semibold)
                        Text("night")
                    }
                    .foregroundStyle(.black)
                }
                
                Spacer()
                
                //rating
                
                StarRatingView(rating: listing.rating)
                    .foregroundStyle(.black)
            }
            .font(.footnote)
        }
        .padding()
    }
}

#Preview {
    ListingItemView(listing: DeveloperPreview.shared.listings.first!)
}


