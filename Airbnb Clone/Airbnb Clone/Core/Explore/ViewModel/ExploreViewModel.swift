//
//  ExploreViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import Foundation
import _MapKit_SwiftUI
import FirebaseFirestore

class ExploreViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    
    @Published var listingReviews: [Review] = []
    @Published private var currentListing: Listing? = nil
    //@Published var currentListingRating: Double = 0
    
    @Published var listingRatings: [String : Double] = [:]
    
    @Published var listing: Listing? = nil
    
    @Published var wishlistListings: [String] = []
    
    @Published var rating: Double = 0
    //@Published var isSaved: Bool = false
    
    @Published var cameraPosition: MapCameraPosition
    
    // DESTINATION DETAILS
    @Published var location: City?
    
    @Published var selectedDateInterval: Double = 0
    
    @Published var showExploreView: Bool = false
    
    @Published var startDate: Date?
    @Published var endDate: Date? {
        didSet {
            guard let endDate = endDate, let startDate = startDate else { return }
            selectedDateInterval = (endDate.timeIntervalSince(startDate)) / 86_400
        }
    }
    
    @Published var guests: (adults: Int, children: Int, infants: Int, pets: Int) = (1, 0, 0, 0)
    
    var dateRangeDescription: String {
        return "\(Global.main.getMonthName(from: Calendar.current.component(.month, from: startDate!))) \(Calendar.current.component(.day, from: startDate!)) - \(Calendar.current.component(.month, from: startDate!) == Calendar.current.component(.month, from: endDate!) ? Calendar.current.component(.day, from: endDate!).description : Global.main.getMonthName(from: Calendar.current.component(.month, from: endDate!)) + " " + Calendar.current.component(.day, from: endDate!).description)"
    }
    
    init() {
        self._cameraPosition = Published(initialValue: .region(.init(center: .init(), span: .init())))
        
        startDate = Date()
        endDate = Date().addingTimeInterval(432_000)
    }
    
    func fetchListings() {
        listings.removeAll()
        Task {
            do {
                let querySnapshot = try await Firestore.firestore().collection("listings").whereField("city", in: [self.location!.cityName]).whereField("numberOfGuests", isGreaterThanOrEqualTo: numberOfGuests()).getDocuments()
                try await MainActor.run {
                    for document in querySnapshot.documents {
                        if !listings.contains(where: { listing in
                            listing.id == document.documentID
                        }) {
                            let listing = try document.data(as: Listing.self)
                            self.listings.append(listing)
                            getListingReviews(listing: listing)
                        }
                    }
                }
                //listings fetched
            } catch {
                return
            }
        }
        fetchWishlistListings()
    }
    
    func numberOfGuests() -> Int {
        return guests.adults + guests.children + guests.infants
    }
    
    func timeIntervalIntersection(ranges: [TimeInterval], firstRef: Date?, secondRef: Date?) -> Bool {
        guard let firstRef = firstRef else {
            return false
        }
        guard let secondRef = secondRef else {
            return false
        }
        let _firstRef = firstRef.timeIntervalSince1970
        let _secondRef = secondRef.timeIntervalSince1970
        for i in 0..<(ranges.count / 2) {
            let first = ranges[i * 2]
            let second = ranges[(i * 2) + 1]
            
            if second > _firstRef && first < _secondRef {
                return false
            }
        }
        
        return true
    }
    
    private func fetchListingReviews(listing: Listing) async {
        for reviewId in listing.reviews {
            do {
                guard !reviewId.isEmpty, !listingReviews.contains(where: { review in
                    review.id == reviewId
                }) else { return }
                let review = try await NetworkManager<Review>.decodeDocument(collectionPath: "listings/\(listing.id)/reviews", documentId: reviewId)
                
                await MainActor.run {
                    listingReviews.append(review)
                }
            } catch {
                return
            }
        }
    }
    
    public func fetchWishlistListings() {
        //Validate the user
        guard let currentUser = Global.main.currentUser else { return }
        // Set the wishlist collection used for UI to the collection that was fetched from the database
        self.wishlistListings = currentUser.wishlist
    }
    
    public func totalPrice() -> Double {
        guard let currentListing = self.listing else { return 0 }
        return currentListing.pricePerNight * (endDate!.timeIntervalSince(startDate!) / 86_400)
    }
    
    public func getListingReviews(listing: Listing) {
        Task {
            //Make sure that the listing that requested the rating calculation is different from the one that is in memory
            //guard self.currentListing != listing else { return }
            
            //Go to the main thread before publishing the changes
            await MainActor.run {
                //Reset the rating for the listing
                //listingRatings[listing.id] = 0
                
                //Update the listing in memory
                //self.currentListing = listing
                
                //Reset all reviews
                self.listingReviews.removeAll()
            }
            
            await fetchListingReviews(listing: listing)
            //calculate rating
            //guard !listingReviews.isEmpty else { return }
//            await MainActor.run {
//                //Calculate the average
//                //listingRatings[listing.id]! /= Double(listingReviews.count)
//            }
        }
    }
    
    public func addToWishlist(_ listing: Listing) {
        //make sure that the user exists
        guard Global.main.currentUser != nil else { return }
        //add to the user's collection
        Global.main.currentUser!.wishlist.append(listing.id)
        
        //add to the collection used in ui
        wishlistListings.append(listing.id)
    }
    
    public func removeFromWishlist(_ listing: Listing) {
        //Make sure that the user exists
        guard Global.main.currentUser != nil else { return }
        
        //remove from the user's collection
        Global.main.currentUser!.wishlist.removeAll(where: { id in
            id == listing.id
        })
        
        //remove from the published collection used in ui
        wishlistListings.removeAll { listingId in
            listingId == listing.id
        }
    }
}
