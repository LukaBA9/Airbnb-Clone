//
//  SaveButton.swift
//  Airbnb Clone
//
//  Created by Luka on 19.4.25..
//

import SwiftUI

struct SaveButton: View {
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    let listing: Listing
    
    var body: some View {
        Button {
            //validate that the user exists
            guard let user = Global.main.currentUser else {
                //no user
                return
            }
            
            if !user.wishlist.contains(where: { id in
                id == listing.id
            }) {
                //user doesn't contain the wishlist, add it to the list
                exploreViewModel.addToWishlist(listing)
            } else {
                //user doesn't contain the wishlist, remove it from the list
                exploreViewModel.removeFromWishlist(listing)
            }
        } label: {
            Image(systemName: exploreViewModel.wishlistListings.contains(where: { listingId in
                listingId == listing.id
            }) ? "heart.fill" : "heart")
                .foregroundStyle(exploreViewModel.wishlistListings.contains(where: { listingId in
                    listingId == listing.id
                }) ? .pink : .black)
                .background {
                    Circle()
                        .fill(.white)
                        .frame(width: 32, height: 32)
                }
        }
    }
}
