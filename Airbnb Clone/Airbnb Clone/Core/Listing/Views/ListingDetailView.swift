//
//  ListingDetailView.swift
//  Airbnb Clone
//
//  Created by Luka on 17.3.25..
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct ListingDetailView: View {
    let listing: Listing
    
    @State private var cameraPosition: MapCameraPosition
    
    @State private var showAllReviews: Bool = false
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(listing: Listing) {
        self.listing = listing
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: listing.latitude, longitude: listing.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        if showAllReviews {
            ReviewsView(showReviewsView: $showAllReviews, reviews: exploreViewModel.listingReviews)
                .environmentObject(ReviewsViewModel())
        }
        else {
            VStack(spacing: 0) {
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        ListingImageCarouselView(listing: listing)
                            .frame(height: 320)
                        
                        HStack(spacing: 21) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                                    .background {
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 32, height: 32)
                                    }
                                    .padding(.vertical, 51)
                            }
                            
                            Spacer()
                            SaveButton(listing: listing)
                        }
                        .padding(.horizontal, 27)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(listing.title)")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 2) {
                                StarRatingView(rating: listing.rating)
                                    .foregroundStyle(.black)
                                
                                Text(listing.reviews.count > 0 ? (listing.reviews.count == 1 ? " - 1 review" : " - \(listing.reviews.count) reviews") : "")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.black)
                            
                            Text("\(listing.city), \(listing.state)")
                        }
                        .font(.caption)
                    }
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    //Host info view
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(ListingType(rawValue: listing.type)?.title ?? "listing") hosted by \(listing.ownerName)")
                                .font(.headline)
                                .frame(width: 250, alignment: .leading)
                            
                            HStack {
                                Text("\(listing.numberOfGuests) guests -")
                                Text("\(listing.numberOfBedrooms) bedrooms -")
                                Text("\(listing.numberOfBeds) beds -")
                                Text("\(listing.numberOfBathrooms) baths")
                            }
                            .font(.caption)
                        }
                        .frame(width: 300, alignment: .leading)
                        
                        Spacer()
                        
                        Image(listing.ownerImageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    Divider()
                    
                    // listing features
                    
                    VStack(alignment: .leading, spacing:  16) {
                        ForEach(listing.features, id: \.self) { feature in
                            let feature = ListingFeatures(rawValue: feature)
                            HStack(spacing: 12) {
                                Image(systemName: feature!.imageName)
                                
                                VStack(alignment: .leading) {
                                    Text(feature!.title)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                    Text(feature!.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Divider()
                    
                    //bedrooms view
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Where you'll sleep")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(1...listing.numberOfBedrooms, id: \.self) { bedroom in
                                    VStack {
                                        Image(systemName: "bed.double")
                                        Text("Bedroom \(bedroom)")
                                            
                                    }
                                    .frame(width: 132, height: 100)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                    }
                    .padding()
                    
                    Divider()
                    
                    //listing amenities
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What this place offers")
                            .font(.headline)
                        
                        ForEach(listing.amenities, id: \.self) { amenity in
                            let amenity = ListingAmenity(rawValue: amenity)
                            HStack() {
                                Image(systemName: amenity!.imageName)
                                    .frame(width: 32)
                                Text(amenity!.title)
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Where you'll be")
                            .font(.headline)
                        
                        Map(position: $cameraPosition)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                    
                    if !listing.reviews.isEmpty {
                        VStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Text(listing.rating.description)
                                    Text("•")
                                    Text("\(listing.reviews.count) reviews")
                                }
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(exploreViewModel.listingReviews) { review in
                                            //Text(review.description)
                                            ReviewView(review: review)
                                        }
                                    }
                                    //Get the ratings
                                }
                                .scrollIndicators(.hidden)
                                Spacer()
                            }
                            //.padding()
                            Button {
                                //show all reviews
                                showAllReviews = true
                            } label: {
                                Text("Show all reviews")
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.gray.opacity(0.22), in: RoundedRectangle(cornerRadius: 9))
                            }
                        }
                        .padding()
                    }
                    else {
                        Text("Not rated yet")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .padding()
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                .ignoresSafeArea()
                
                VStack {
                    Divider()
                        .padding(.bottom)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("$\(exploreViewModel.totalPrice().formattedDesription)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("Total before taxes")
                                .font(.footnote)
                            Text(exploreViewModel.dateRangeDescription)
                            .font(.footnote)
                            .fontWeight(.semibold)
                        }
                        Spacer()
                        
                        NavigationLink(destination: ReserveView(listing: listing)) {
                            Text("Reserve")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 140, height: 40)
                                .background(.pink)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 32)
                }
                .background(.white)
            }
            .onAppear() {
                exploreViewModel.listing = self.listing
                //exploreViewModel.userLikesListing()
            }
        }
    }
}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings.first!)
}
