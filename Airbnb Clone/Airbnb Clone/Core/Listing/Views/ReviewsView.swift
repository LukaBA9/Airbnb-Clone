//
//  ReviewsView.swift
//  Airbnb Clone
//
//  Created by Luka on 4.4.25..
//

import SwiftUI
import FirebaseFirestore

struct ReviewsView: View {
    
    @EnvironmentObject var reviewsViewModel: ReviewsViewModel
    
    @Binding var showReviewsView: Bool
    
    let reviews: [Review]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    //get back
                    withAnimation(.snappy(duration: 0.3)) {
                        showReviewsView = false
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(6)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                        .foregroundStyle(.black)
                }

                Spacer()
            }
            
            HStack {
                ReviewChart(reviews: reviews)
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(RatingTypes.allCases) { type in
                            HStack(alignment: .top) {
                                Divider()
                                    .frame(height: 100)
                                VStack(alignment: .leading) {
                                    Text(type.id)
                                        .fontWeight(.semibold)
                                    Text(reviewsViewModel.averageRatings[type]?.description ?? "Not rated")
                                }
                            }
                            .frame(width: 120)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.bottom, 21)
            
            HStack(alignment: .top) {
                Group {
                    Text("\(reviews.count)")
                    Text(reviews.count == 1 ? "review" : "reviews")
                }
                .font(.title3)
                .fontWeight(.semibold)
                Spacer()
            }
            reviewsView
            Spacer()
        }
        .padding()
        .onAppear() {
            //calculate the average ratings
            reviewsViewModel.averageRatings(reviews: reviews)
        }
    }
    
    private var reviewsView: some View {
        ScrollView (.vertical, showsIndicators: false) {
            ForEach(reviews) { review in
                VStack(alignment: .leading, spacing: 9) {
                    Text(reviewsViewModel.users[review.id]?.name ?? "Guest user")
                    HStack(spacing: 1) {
                        ForEach(0..<5) { index in
                            Image(systemName: "star.fill")
                                .foregroundStyle(.gray.opacity(0.42))
                                .font(.caption)
                                .overlay {
                                    if index < review.stars {
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundStyle(.black)
                                    }
                                }
                        }
                    }
                    Text(review.description)
                    Divider()
                        .padding(.vertical)
                }
                //.padding(.bottom, 15)
                .task {
                    do {
                        try await reviewsViewModel.fetchData(userId: review.userId, reviewId: review.id)
                    } catch {
                        return
                    }
                }
            }
        }
    }
}

struct ReviewChart: View {
    let reviews: [Review]
    @EnvironmentObject var reviewsViewModel: ReviewsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            if reviewsViewModel.ratingPerecentageNormalized.count == 5 {
                Text("Overall rating")
                    .font(.system(size: 15))
                VStack(alignment: .leading, spacing: 1){
                    ForEach(0..<5) { index in
                        HStack {
                            Text("\(5 - index)")
                                .foregroundStyle(.black.opacity(0.75))
                                .font(.caption)
                            Spacer()
                            Capsule()
                                .foregroundStyle(.black)
                                .frame(width: 90 * reviewsViewModel.ratingPerecentageNormalized[5 - index - 1], height: 4)
                                .frame(width: 90, alignment: .leading)
                                .background(.gray.opacity(0.3), in: Capsule())
                        }
                    }
                }
                .frame(width: 110)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear() {
            //retrieve ratings
            reviewsViewModel.calculateRatingCount(reviews: reviews)
        }
    }
}

#Preview {
    ReviewsView(showReviewsView: .constant(true), reviews: [Review(id: "1", cleanliness: 4, check_in: 5, location: 5, value: 5, description: "asdasfaf", userId: "rhkKJfGM4xOIlTwLhNTpRtr9j5H2"), Review(id: "2", cleanliness: 5, check_in: 5, location: 5, value: 5, description: "asdasfaf", userId: "")])
        .environmentObject(ReviewsViewModel())
}
