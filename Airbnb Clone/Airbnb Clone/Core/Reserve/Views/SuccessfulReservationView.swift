//
//  SuccessfulReservationView.swift
//  Airbnb Clone
//
//  Created by Luka on 31.3.25..
//

import SwiftUI

struct SuccessfulReservationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Congratulations, you successfully booked a place!")
                .font(.title)
                .fontWeight(.semibold)
            Button {
                //return to home page
                dismiss()
            } label: {
                Text("Return to home page")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .underline()
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    SuccessfulReservationView()
}
