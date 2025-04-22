//
//  CitySearchResultView.swift
//  Airbnb Clone
//
//  Created by Luka on 19.3.25..
//

import SwiftUI

struct CitySearchResultView: View {
    let city: City
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 24) {
                Image(systemName: "mappin.and.ellipse.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52)
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(city.cityName), \(city.country.rawValue)")
                        .font(.headline)
                }
            }
            .foregroundStyle(.black)
        }

    }
}

#Preview {
    CitySearchResultView(city: DeveloperPreview.shared.cities.first!, action: {})
}
