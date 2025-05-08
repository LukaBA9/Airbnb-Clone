//
//  SearchAndFilterBar.swift
//  Airbnb Clone
//
//  Created by Luka on 16.3.25..
//

import SwiftUI

struct SearchAndFilterBar: View {
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Where to")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("\(exploreViewModel.location?.cityName ?? "Anywhere") • \(exploreViewModel.dateRangeDescription) • \(exploreViewModel.numberOfGuests()) \(exploreViewModel.numberOfGuests() == 1 ? "guest" : "guests")")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                //
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.black)
            }

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
}

#Preview {
    SearchAndFilterBar()
}
