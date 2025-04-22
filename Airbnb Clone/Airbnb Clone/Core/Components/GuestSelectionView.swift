//
//  GuestSelectionView.swift
//  Airbnb Clone
//
//  Created by Luka on 22.4.25..
//


import SwiftUI
import UIKit
import HorizonCalendar

struct GuestSelectionView: View {
    @Binding var temporarySearchFilter: (adults: Int, children: Int, infants: Int, pets: Int)
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    var numberOfGuests: Int {
        return temporarySearchFilter.adults + temporarySearchFilter.children + temporarySearchFilter.pets + temporarySearchFilter.infants
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Who's coming")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Adults")
                    Text("Ages 13 or above")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button {
                    temporarySearchFilter.adults -= 1
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.adults <= 0 || numberOfGuests <= 1)
                .foregroundStyle(temporarySearchFilter.adults <= 0 || numberOfGuests <= 1 ? .gray : .black)
                Text(temporarySearchFilter.adults.description)
                    .frame(maxWidth: 20)
                Button {
                    temporarySearchFilter.adults += 1
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.adults >= 10)
                .foregroundStyle(temporarySearchFilter.adults >= 10 ? .gray : .black)
            }
            .padding(.vertical)
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Children")
                    Text("Ages 2 - 12")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button {
                    temporarySearchFilter.children -= 1
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.children <= 0 || numberOfGuests <= 1)
                .foregroundStyle(temporarySearchFilter.children <= 0 || numberOfGuests <= 1 ? .gray : .black)
                Text(temporarySearchFilter.children.description)
                    .frame(maxWidth: 20)
                Button {
                    temporarySearchFilter.children += 1
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.children >= 10)
                .foregroundStyle(temporarySearchFilter.children >= 10 ? .gray : .black)
            }
            .padding(.vertical)
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Infants")
                    Text("Under 2")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button {
                    temporarySearchFilter.infants -= 1
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.infants <= 0 || numberOfGuests <= 1)
                .foregroundStyle(temporarySearchFilter.infants <= 0 || numberOfGuests <= 1 ? .gray : .black)
                Text(temporarySearchFilter.infants.description)
                    .frame(maxWidth: 20)
                Button {
                    temporarySearchFilter.infants += 1
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.infants >= 10)
                .foregroundStyle(temporarySearchFilter.infants >= 10 ? .gray : .black)
            }
            .padding(.vertical)
            Divider()
            HStack {
                Text("Pets")
                Spacer()
                Button {
                    temporarySearchFilter.pets -= 1
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.pets <= 0 || numberOfGuests <= 1)
                .foregroundStyle(temporarySearchFilter.pets <= 0 || numberOfGuests <= 1 ? .gray : .black)
                Text(temporarySearchFilter.pets.description)
                    .frame(maxWidth: 20)
                Button {
                    temporarySearchFilter.pets += 1
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 27, height: 27)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                }
                .disabled(temporarySearchFilter.pets >= 5)
                .foregroundStyle(temporarySearchFilter.pets >= 5 ? .gray : .black)
            }
            .padding(.vertical)
        }
    }
}
