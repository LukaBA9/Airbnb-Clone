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
    
    @Published var listingRatings: [String : Double] = [:]
    
    @Published var listing: Listing? = nil
    
    @Published var wishlistListings: [String] = []
    
    @Published var rating: Double = 0
    
    @Published var cameraPosition: MapCameraPosition
    
    // DESTINATION DETAILS
    @Published var location: City?
    
    @Published var selectedDateInterval: Double = 0
    
    @Published var showExploreView: Bool = false
    
    @Published var startDate: Date?
    @Published var endDate: Date? {
        didSet {
            //Everytime the endDate is updated, that means that the startDate is also updated,
            //which means that the date interval needs recalculation
            guard let endDate = endDate, let startDate = startDate else { return }
            selectedDateInterval = (endDate.timeIntervalSince(startDate)) / 86_400
        }
    }
    
    @Published var guests: (adults: Int, children: Int, infants: Int, pets: Int) = (1, 0, 0, 0)
    
    var dateRangeDescription: String {
        //This is the human-readable format of a date range the user selected. Example: May 12 - 18, May 31 - June 03
        return "\(Global.main.getMonthName(from: Calendar.current.component(.month, from: startDate!))) \(Calendar.current.component(.day, from: startDate!)) - \(Calendar.current.component(.month, from: startDate!) == Calendar.current.component(.month, from: endDate!) ? Calendar.current.component(.day, from: endDate!).description : Global.main.getMonthName(from: Calendar.current.component(.month, from: endDate!)) + " " + Calendar.current.component(.day, from: endDate!).description)"
    }
    
    init() {
        //This is not affecting the map view. The compiler requires the cameraPosition to be initialised, but the exploreView can never be accessed before the user selects the location where he wants to book accomodations
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
        //Total price is calculated by multiplying the date interval with the price per night of the listing
        guard let currentListing = self.listing else { return 0 }
        return currentListing.pricePerNight * (endDate!.timeIntervalSince(startDate!) / 86_400)
    }
    
    public func getListingReviews(listing: Listing) {
        Task {
            //Go to the main thread before publishing the changes
            await MainActor.run {
                
                //Reset all reviews
                self.listingReviews.removeAll()
            }
            
            await fetchListingReviews(listing: listing)
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
    
    public func updateCameraPosition(latitude: Double, longitude: Double) {
        //This method updates the center position of the camera for the map view whenever the location is updated
        cameraPosition = .region(.init(center: .init(latitude: latitude, longitude: longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    public func updateSearchFilters(location: City?, checkInDate: Date?, checkOutDate: Date?, guests: (adults: Int, children: Int, infants: Int, pets: Int)) {
        //When the user updates the search filters, the new settings are stored in temporary variables, so they wouldn't affect the actual data if the user desides to quit. When the user presses search button, this method is called, updating the data.
        self.location = location
        self.guests = guests
        self.startDate = checkInDate
        self.endDate = checkOutDate
    }
}
