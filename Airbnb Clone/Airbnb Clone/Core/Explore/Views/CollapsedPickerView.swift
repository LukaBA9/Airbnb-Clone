//
//  ExtractedView.swift
//  Airbnb Clone
//
//  Created by Luka on 17.3.25..
//


import SwiftUI

struct CollapsedPickerView: View {
    let title: String
    let description: String
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.gray)
                Spacer()
                
                Text(description)
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
    }
}
