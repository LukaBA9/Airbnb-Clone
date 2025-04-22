//
//  ExploreView.swift
//  Airbnb Clone
//
//  Created by Luka on 16.3.25..
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct ExploreView: View {
    
    @State private var showDestinationSearchView = false
    @State private var showMap = false
    
    @State private var highlightedListing: Listing? = nil
    @State private var hideExploreView: Bool = false
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    var filteredListings: [Listing] {
        exploreViewModel.listings.filter { listing in
            return
                exploreViewModel.timeIntervalIntersection(ranges: listing.bookedDates, firstRef: exploreViewModel.startDate, secondRef: exploreViewModel.endDate)
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .top) {
                    GeometryReader { proxy in
                        ZStack(alignment: .bottom) {
                            Map(position: $exploreViewModel.cameraPosition) {
                                ForEach(filteredListings) { listing in
                                    let latitude = listing.latitude
                                    let longitude = listing.longitude
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    Annotation("", coordinate: coordinate) {
                                        Button {
                                            if let highlightedListing = highlightedListing {
                                                if highlightedListing.id == listing.id { return }
                                            }
                                            self.highlightedListing = listing
                                            
                                        } label: {
                                            Text("$\(listing.pricePerNight.formattedDesription)")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                                .padding(9)
                                                .background(highlightedListing?.id == listing.id ? .black : .pink, in: RoundedRectangle(cornerRadius: 25))
                                                .shadow(radius: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            if highlightedListing != nil {
                                VStack {
                                    Spacer()
                                    NavigationLink(value: highlightedListing!) {
                                        SlideInListingPreviewView(highlightedListing: $highlightedListing)
                                    }
                                    .foregroundStyle(.black)
                                    .padding()
                                }
                            }
                            
                            CustomSheet(height: proxy.size.height - 105, isPresented: $showMap, hide: $hideExploreView) {
                                VStack {
                                    Spacer(minLength: 36)
                                    ScrollView {
                                        LazyVStack(spacing: 32) {
                                            ForEach(filteredListings) { listing in
                                                NavigationLink(value: listing) {
                                                    ListingItemView(listing: listing)
                                                        .frame(height: 400)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                            }
                                        }
                                    }
                                }
                                .background(Color.white)
                                
                            }
                        }
                    }
                    .overlay {
                        if !showMap {
                            VStack {
                                Spacer()
                                Button {
                                    withAnimation(.smooth(duration: 0.3)) {
                                        showMap = true
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "location.fill")
                                        Text("Map")
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(.black, in: RoundedRectangle(cornerRadius: 25))
                                }
                                .padding(.bottom, 21)
                            }
                        }
                    }
                    .navigationDestination(for: Listing.self) { listing in
                        ListingDetailView(listing: listing)
                            .toolbar(.hidden)
                    }
                    .toolbar(.hidden)
                    
                    SearchAndFilterBar()
                        .background(.white)
                        .onTapGesture {
                            withAnimation(.snappy(duration: 0.3)) { showDestinationSearchView.toggle() }
                        }
                }
            }
            if showDestinationSearchView {
                DestinationSearchView(show: $showDestinationSearchView)
                    .background(.white)
            }
        }
        .onAppear() {
            if exploreViewModel.location == nil { showDestinationSearchView = true }
            else {
                exploreViewModel.fetchWishlistListings()
            }
        }
        .onChange(of: highlightedListing) {
            if highlightedListing != nil {
                hideExploreView = true
            }
            else {
                hideExploreView = false
            }
        }
    }
}



struct SlideInListingPreviewView: View {
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    @State private var offset: CGFloat = 550
    
    @Binding var highlightedListing: Listing?
    let listing: Listing
    
    init(highlightedListing: Binding<Listing?>) {
        self._highlightedListing = highlightedListing
        guard let listing = highlightedListing.wrappedValue else {
            fatalError("No listing provided")
        }
        self.listing = listing
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                ListingImageCarouselView(listing: listing)
                    .frame(height: 210)
                HStack(spacing: 21) {
                    Button {
                        //dismiss
                        withAnimation(.easeOut(duration: 0.3)) {
                            highlightedListing = nil
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 32, height: 32)
                            }
                            .padding(27)
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(listing.title)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    StarRatingView(rating: listing.rating)
                }
                Text("$\(listing.pricePerNight.formattedDesription) night")
            }
            .font(.caption)
            .padding()
        }
        .frame(width: 350)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .offset(y: offset)
        .onAppear() {
            withAnimation(.easeInOut(duration: 0.3)) {
                offset = 0
            }
        }
        .onDisappear() {
            highlightedListing = nil
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(ExploreViewModel())
}
