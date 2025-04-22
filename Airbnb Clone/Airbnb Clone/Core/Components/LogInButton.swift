//
//  ExtractedView.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//


import SwiftUI

struct LogInButton: View {
    var body: some View {
        Button {
            print("Log in")
        } label: {
            Text("Log in")
                .foregroundStyle(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 360, height: 48)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
