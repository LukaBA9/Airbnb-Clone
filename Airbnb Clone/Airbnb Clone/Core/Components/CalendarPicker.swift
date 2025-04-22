//
//  CalendarPicker.swift
//  Airbnb Clone
//
//  Created by Luka on 25.3.25..
//

import Foundation
import SwiftUI
import HorizonCalendar
import UIKit

struct CalendarPicker: View {
    
    @EnvironmentObject var exploreViewModel: ExploreViewModel
    
    @State private var selectedDate: Date? = nil

    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    
    @State private var datesToHighlight: [Date] = []
    
    @State private var dateRangeToHighlight: ClosedRange<Date>? = nil
    
    @Binding var checkInDate: Date?
    @Binding var checkOutDate: Date?
    
    var body: some View {
        let calendar = Calendar.current
        
        let currentDate = calendar.dateComponents([.year, .month, .day], from: Date())
        let minDate = calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day))!.addingTimeInterval(86_400)
        let maxDate = calendar.date(from: DateComponents(year: currentDate.year! + 1, month: currentDate.month, day: currentDate.day))!
        
        CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: minDate...maxDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
            dataDependency: nil
        )
        .days { day in
            let date = calendar.date(from: day.components)
            Text("\(day.day)")
              .font(.system(size: 18))
              .foregroundColor(datesToHighlight.contains(where: { id in
                  Calendar.current.dateComponents([.year, .month, .day], from: id) == Calendar.current.dateComponents([.year, .month, .day], from: date!)
              }) ? .white : .black)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(datesToHighlight.contains(where: { id in
                  Calendar.current.dateComponents([.year, .month, .day], from: id) == Calendar.current.dateComponents([.year, .month, .day], from: date!)
              }) ? .black.opacity(0.9) : .clear, in: Circle())
          }
        .onDaySelection { day in
            selectedDate = calendar.date(from: day.components)
            if startDate != nil, selectedDate! > startDate!, endDate == nil {
                endDate = selectedDate
                datesToHighlight.append(selectedDate!)
                dateRangeToHighlight = startDate!...endDate!
                checkInDate = startDate!
                checkOutDate = endDate!
                return
            }
            startDate = selectedDate
            endDate = nil
            datesToHighlight.removeAll()
            datesToHighlight.append(selectedDate!)
            dateRangeToHighlight = nil
            return
          }
        .dayRanges(for: dateRangeToHighlight != nil ? [dateRangeToHighlight!] : [], { dayRangeLayoutContext in
            DayRangeIndicatorViewRepresentable(framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame })
        })
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            datesToHighlight.append(contentsOf: [exploreViewModel.startDate!, exploreViewModel.endDate!])
            dateRangeToHighlight = exploreViewModel.startDate!...exploreViewModel.endDate!
            print(datesToHighlight.first!.description)
        }
    }
}

final class DayRangeIndicatorView: UIView {

  private let indicatorColor: UIColor

  init(indicatorColor: UIColor) {
    self.indicatorColor = indicatorColor
    super.init(frame: .zero)
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  var framesOfDaysToHighlight = [CGRect]() {
    didSet {
      guard framesOfDaysToHighlight != oldValue else { return }
      setNeedsDisplay()
    }
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(indicatorColor.cgColor)

    // Get frames of day rows in the range
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in framesOfDaysToHighlight {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }

    // Draw rounded rectangles for each day row
    for dayRowFrame in dayRowFrames {
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: 12)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }

}

struct DayRangeIndicatorViewRepresentable: UIViewRepresentable {

  let framesOfDaysToHighlight: [CGRect]

  func makeUIView(context: Context) -> DayRangeIndicatorView {
    DayRangeIndicatorView(indicatorColor: UIColor.systemBlue.withAlphaComponent(0.15))
  }

  func updateUIView(_ uiView: DayRangeIndicatorView, context: Context) {
    uiView.framesOfDaysToHighlight = framesOfDaysToHighlight
  }

}

#Preview {
    CalendarPicker(checkInDate: .constant(Date()), checkOutDate: .constant(Date()))
        .environmentObject(ExploreViewModel())
}
