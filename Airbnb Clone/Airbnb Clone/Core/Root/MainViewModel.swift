//
//  MainViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 28.3.25..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MainViewModel : ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    @Published var currentUser: User?
    //@Published var wishlistListings: [Listing] = []
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async { [weak self] in
                print("state changed")
                guard let user = user else { return }
                let userRef = Firestore.firestore().collection("users").document(user.uid)
                Task {
                    do {
                        self?.currentUser = try await userRef.getDocument(as: User.self)
                        Global.main.currentUser = self?.currentUser
                    }
                    catch {
                        fatalError("Couldn't fetch user data")
                    }
//                    for id in Global.main.currentUser?.wishlist ?? [] {
//                        //fetch
//                        let db = Firestore.firestore()
//                        do {
//                            let listing = try await db.collection("listings").document(id).getDocument(as: Listing.self)
//                            self?.wishlistListings.append(listing)
//                        } catch {
//                            //error
//                            return
//                        }
//                    }
                }
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
