//
//  ReviewView.swift
//  Airbnb Clone
//
//  Created by Luka on 1.4.25..
//

import SwiftUI
import FirebaseFirestore

struct ReviewView: View {
    @State private var user: User? = nil
    @State private var isExceeding: Bool = false
    @State private var reviewDescriptionText: String = ""
    let review: Review
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(0..<5) { star in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(star < review.stars ? .black : .gray.opacity(0.5))
                }
            }
            Text(reviewDescriptionText)
            
            if isExceeding {
                Button {
                    //
                } label: {
                    Text("Show more")
                        .underline()
                }

            }
            
            Spacer()
            //fetch user
            Text(user?.name ?? "Guest user")
        }
        .frame(width: 180, height: 168)
        .padding()
        .onAppear() {
            //fetch user
            Task {
                do {
                    user = try await Firestore.firestore().collection("users").document(review.userId).getDocument(as: User.self)
                } catch {
                    return
                }
            }
            reviewDescriptionText = review.description
            let descrptionCount = reviewDescriptionText.count
            if descrptionCount > 75 {
                isExceeding = true
                reviewDescriptionText.removeLast(descrptionCount - 72)
                reviewDescriptionText.append("...")
            }
        }
    }
}
