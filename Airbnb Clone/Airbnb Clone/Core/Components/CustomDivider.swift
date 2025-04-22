//
//  CustomDivider.swift
//  Airbnb Clone
//
//  Created by Luka on 19.3.25..
//

import SwiftUI

struct CustomDivider: View {
    let color: Color
    let width: CGFloat
    
    init() {
        color = .gray
        width = 1
    }
    
    init(width: CGFloat, color: Color) {
        self.width = width
        self.color = color
    }
    
    var body: some View {
        Rectangle()
            .frame(height: width)
            .foregroundColor(color)
    }
}

#Preview {
    CustomDivider()
}
