//
//  MainTabVie.swift
//  Airbnb Clone
//
//  Created by Luka on 18.3.25..
//

import SwiftUI

struct MainTabView: View {
    
    private var exploreViewModel: ExploreViewModel = ExploreViewModel()
    var body: some View {
        TabView {
            ExploreView()
                .environmentObject(exploreViewModel)
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
            
            WishlistsView()
                .environmentObject(exploreViewModel)
                .tabItem {
                    Label("Wishlists", systemImage: "heart")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainTabView()
}
