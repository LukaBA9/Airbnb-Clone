//
//  ReviewsViewModel.swift
//  Airbnb Clone
//
//  Created by Luka on 6.4.25..
//

import Foundation

enum RatingTypes: String, Identifiable, Hashable, CaseIterable {
    case value = "Value"
    case cleanliness = "Cleanliness"
    case check_in = "Check in"
    case location = "Location"
    
    var id: String { return self.rawValue }
}

class ReviewsViewModel: ObservableObject {
    
    @Published var averageRatings: [RatingTypes : Double] = [:]
    @Published var users: [String : User] = [:]
    
    @Published var ratingCount: [Int] = Array(repeating: 0, count: 5)
    @Published var ratingPerecentageNormalized: [Double] = Array(repeating: 0, count: 5)
    
    func fetchData(userId: String, reviewId: String) async throws {
        do {
            if !userId.isEmpty {
                let user = try await NetworkManager<User>.decodeDocument(collectionPath: "users", documentId: userId)
                    
                //add to the collection
                await MainActor.run {
                    users[reviewId] = user
                }
            }
        } catch let error {
            throw error
        }
    }
    
    func averageRatings(reviews: [Review]) {
        for review in reviews {
            if averageRatings[.check_in] != nil {
                averageRatings[.check_in]! += Double(review.check_in) / Double(reviews.count)
            } else {
                averageRatings[.check_in] = Double(review.check_in) / Double(reviews.count)
            }
            
            if averageRatings[.location] != nil {
                averageRatings[.location]? += Double(review.location) / Double(reviews.count)
            } else {
                averageRatings[.location] = Double(review.location) / Double(reviews.count)
            }
            
            if averageRatings[.value] != nil {
                averageRatings[.value]! += Double(review.value) / Double(reviews.count)
            } else {
                averageRatings[.value] = Double(review.value) / Double(reviews.count)
            }
            
            if averageRatings[.cleanliness] != nil {
                averageRatings[.cleanliness]! += Double(review.cleanliness) / Double(reviews.count)
            } else {
                averageRatings[.cleanliness] = Double(review.cleanliness) / Double(reviews.count)
            }
        }
    }
    
    func calculateRatingCount(reviews: [Review]) {
        for review in reviews {
            let rating = review.stars
            ratingCount[rating - 1] += 1
        }
        
        //calculate perecetages
        for i in 0..<5 {
            ratingPerecentageNormalized[i] = Double(ratingCount[i]) / Double(reviews.count)
        }
    }
}
