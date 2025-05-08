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
    
    @State private var currIntervalLowerBound: Int = 0
    
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
              .foregroundColor(isDateAvailable(date: date!) ? (isDateSelected(date!) ? .white : .black) : .gray)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(isDateSelected(date!) ? .black.opacity(0.9) : .clear, in: Circle())
        }
        .onDaySelection { day in
            guard let selectedDate = calendar.date(from: day.components) else { return }
            guard isDateAvailable(date: selectedDate) else { return }
            if startDate != nil, selectedDate > startDate!, endDate == nil {
                endDate = selectedDate
                datesToHighlight.append(selectedDate)
                dateRangeToHighlight = startDate!...endDate!
                checkInDate = startDate!
                checkOutDate = endDate!
                return
            }
            startDate = selectedDate
            endDate = nil
            datesToHighlight.removeAll()
            datesToHighlight.append(selectedDate)
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
        }
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        datesToHighlight.contains(where: { id in
            Calendar.current.dateComponents([.year, .month, .day], from: id) == Calendar.current.dateComponents([.year, .month, .day], from: date)
        }) ? true : false
    }
    
    private func isDateAvailable(date: Date) -> Bool {
        //check for whether or not the listing is nil
        //if it isnt, then make sure to not allow selection of any dates that are already booked
        //when the start date is selected, make sure to not allow selection of any dates that are after the lower-bound of the first interval after the start date.
        //if there arent any bookedDates intervals after the start date, allow all the dates after
        
        guard exploreViewModel.listing != nil else { //logic for when the listing isnt choosen
            return Date().smallerThan(date)
        }
        
        //logic for when the the dates are being edited from the reserve view
        
        let dateUNIX = date.timeIntervalSince1970
        
        for i in stride(from: 0, to: exploreViewModel.listing!.bookedDates.count, by: 2) {
            let bookedDateLowerBound = exploreViewModel.listing!.bookedDates[i]
            let bookedDateUpperBound = exploreViewModel.listing!.bookedDates[i + 1]
            
            if dateUNIX >= bookedDateLowerBound && dateUNIX < bookedDateUpperBound {
                return false
            }
            
            if self.startDate != nil && self.endDate == nil {
                if self.startDate!.timeIntervalSince1970 < bookedDateUpperBound && dateUNIX >= bookedDateLowerBound {
                    return false
                }
            }
        }
        
        return Date().smallerThan(date)
    }
}





#Preview {
    CalendarPicker(checkInDate: .constant(Date()), checkOutDate: .constant(Date()))
        .environmentObject(ExploreViewModel())
}
