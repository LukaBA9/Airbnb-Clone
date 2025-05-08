//
//  CustomSheet.swift
//  Airbnb Clone
//
//  Created by Luka on 25.3.25..
//


import SwiftUI
import MapKit

struct CustomSheet<Content: View>: View {
    
    let content: Content
    @State internal var offset: CGFloat
    @Binding var isPresented: Bool
    @Binding var hide: Bool
    let restPositionOffset: CGFloat
    let height: CGFloat
    init(offset: CGFloat = 0, height: CGFloat, restPositionOffset: CGFloat = 36, isPresented: Binding<Bool>, hide: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.height = height
        self.restPositionOffset = restPositionOffset
        self.offset = offset
        self._isPresented = isPresented
        self._hide = hide
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(height: height + restPositionOffset)
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 0, bottomTrailing: 0, topTrailing: 12)))
            .overlay(content: {
                VStack {
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .foregroundStyle(.gray)
                        .padding(8)
                    Spacer()
                }
            })
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height < 0 {
                            offset = gesture.translation.height + height
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.height < -100 {
                            withAnimation {
                                isPresented = false
                            }
                        }
                        else {
                            withAnimation {
                                offset = height
                            }
                        }
                    }
                , isEnabled: isPresented
            )
            .onChange(of: hide) {
                if hide {
                    withAnimation {
                        offset += restPositionOffset
                    }
                }
                else {
                    withAnimation {
                        offset -= restPositionOffset
                    }
                }
            }
            .onChange(of: isPresented) {
                if isPresented {
                    withAnimation(.easeOut(duration: 0.3)) { offset = height }
                }
                else {
                    withAnimation(.easeOut(duration: 0.3)) { offset = 0 }
                }
            }
    }
}
