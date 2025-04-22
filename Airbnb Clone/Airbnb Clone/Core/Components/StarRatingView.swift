//
//  StarRatingView.swift
//  Airbnb Clone
//
//  Created by Luka on 17.3.25..
//


import SwiftUI

struct StarRatingView: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
            Text(rating != 0 ? "\(rating.formatted(.number))" : "Not rated")
        }
    }
}
