//
//  WishlistsView.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import SwiftUI
import FirebaseFirestore

struct WishlistsView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    @StateObject var wishlistViewModel: WishlistViewModel = WishlistViewModel()
    
    var body: some View {
        if !mainViewModel.isSignedIn {
            NavigationStack {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Log in to view your wishlists")
                            .font(.headline)
                        
                        Text("You can create, view or edit wishlists once you've logged in")
                            .font(.footnote)
                    }
                    LogInButton()
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Wishlists")
            }
        } else {
            //display wishlist
            NavigationStack {
                VStack(alignment: .leading) {
                    Text("Your wishlist")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    ScrollView {
                        ForEach(wishlistViewModel.listings) { listing in
                            //get the listing
                            NavigationLink(value: listing) {
                                ListingItemView(listing: listing)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationDestination(for: Listing.self) { listing in
                    ListingDetailView(listing: listing)
                        .toolbar(.hidden)
                }
            }
            .task {
                print("Appeared")
                await wishlistViewModel.fetchListings()
            }
        }
    }
}

#Preview {
    WishlistsView()
}
