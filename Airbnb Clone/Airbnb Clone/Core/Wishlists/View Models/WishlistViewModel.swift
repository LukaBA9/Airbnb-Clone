//
//  WishlistViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 18.4.25..
//

import Foundation
import FirebaseFirestore

class WishlistViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    
    init() {}
    
    public func fetchListings() async {
        await MainActor.run {
            listings.removeAll()
        }
        
        let db = Firestore.firestore()
        guard let currentUser = Global.main.currentUser else { return }
        guard !currentUser.wishlist.isEmpty else { return }
        let query = db.collection("listings").whereField("id", in: currentUser.wishlist)
        
        do {
            let data = try await query.getDocuments()
            
            await MainActor.run {
                for document in data.documents {
                    guard let listing = try? document.data(as: Listing.self) else { continue }
                    listings.append(listing)
                }
            }
        } catch {
            return
        }
    }
}
