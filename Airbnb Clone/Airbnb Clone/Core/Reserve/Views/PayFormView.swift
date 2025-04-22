//
//  PayFormView.swift
//  Airbnb Clone
//
//  Created by Luka on 31.3.25..
//

import SwiftUI
import FirebaseFirestore

enum PayType: String, Hashable, CaseIterable {
    case now
    case inParts
    
    var id: String { self.rawValue }
}

struct PayFormView: View {
    
    let listing: Listing
    
    @State private var payTypeSelection: PayType = .now
    @Binding var reserved: Bool
    
    let totalPrice: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 27) {
            Text("Choose how to pay")
                .font(.title2)
                .padding(.top, 24)
            HStack {
                Text("Pay $\((totalPrice).formatted(.number)) now")
                    .fontWeight(.bold)
                Spacer()
                Button {
                    payTypeSelection = .now
                } label: {
                    Circle()
                        .foregroundStyle(.black)
                        .overlay(content: {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: payTypeSelection == .now ? 8 : 18)
                        })
                        .frame(width: 20)
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text("Pay part now, part later")
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        payTypeSelection = .inParts
                    } label: {
                        Circle()
                            .foregroundStyle(.black)
                            .overlay(content: {
                                Circle()
                                    .foregroundStyle(.white)
                                    .frame(width: payTypeSelection == .inParts ? 8 : 18)
                            })
                            .frame(width: 20)
                    }

                }
                Text("$\((totalPrice / 2).formattedDesription) due today, $\((totalPrice / 2).formattedDesription) on \(Global.main.getMonthName(from: Calendar.current.component(.month, from: Date()) + 1)) \(Calendar.current.component(.day, from: Date())). No extra fees.")
                //make my own format func
            }
            
            Divider()
            
            //cancelation policy
            Text("Cancellation policy")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Free cancellation before \(Global.main.getMonthName(from: Calendar.current.component(.month, from: Date().addingTimeInterval(5 * 86_400)))) \(Calendar.current.component(.day, from: Date().addingTimeInterval(5 * 86_400))). Cancel before \(Global.main.getMonthName(from: Calendar.current.component(.month, from: Date().addingTimeInterval(20 * 86_400)))) \(Calendar.current.component(.day, from: Date().addingTimeInterval(20 * 86_400))) for a partial refund.")
            
            Divider()
            
            //ground rules
            Text("Ground rules")
                .font(.title2)
                .fontWeight(.semibold)
            Text("We ask every guest to remember a few simple things about what makes a great guest.")
            
            Text("• Follow the house rules")
            Text("• Treat your Host's home like your own")
            
            Divider()
            
            Button {
                //confirm and pay
                let trip = Trip(id: UUID().uuidString, listingId: listing.id, wayToPay: payTypeSelection.id)
                //Append trip
                Firestore.firestore().collection("users/\(Global.main.currentUser!.id)/trips").document(trip.id).setData(trip.asDictionary())
                Global.main.currentUser!.trips.append(trip.id)
                withAnimation(.snappy(duration: 0.3)) {
                    reserved = true
                }
            } label: {
                Text("Confirm and pay")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(.pink, in: RoundedRectangle(cornerRadius: 9))
            }
        }
    }
}

#Preview {
    PayFormView(listing: DeveloperPreview.shared.listings.first!, reserved: .constant(false), totalPrice: 0)
}
