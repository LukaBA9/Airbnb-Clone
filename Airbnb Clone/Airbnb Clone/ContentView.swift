//
//  ContentView.swift
//  Airbnb Clone
//
//  Created by Luka on 16.3.25..
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
