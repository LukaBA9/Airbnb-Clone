//
//  DayRangeIndicatorViewRepresentable.swift
//  Airbnb Clone
//
//  Created by Luka on 8.5.25..
//


import Foundation
import SwiftUI
import HorizonCalendar
import UIKit

struct DayRangeIndicatorViewRepresentable: UIViewRepresentable {

  let framesOfDaysToHighlight: [CGRect]

  func makeUIView(context: Context) -> DayRangeIndicatorView {
    DayRangeIndicatorView(indicatorColor: UIColor.systemBlue.withAlphaComponent(0.15))
  }

  func updateUIView(_ uiView: DayRangeIndicatorView, context: Context) {
    uiView.framesOfDaysToHighlight = framesOfDaysToHighlight
  }

}