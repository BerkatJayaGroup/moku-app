//
//  DateExtention.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import Foundation
import SwiftUI

extension Date {

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    static func getWeek(for month: Int = 1, day: Int) -> [BookDate] {
        let day = day
        let bookingRange = 7
        var dates = [BookDate]()
        if day < bookingRange {
            let lastIndex = 7 * ((7 / day) + 1)
            for day in 1...lastIndex {
                if let bookDate = Date.getBookDate(for: day) {
                    dates.append(bookDate)
                }
            }
        } else {
            for day in 1...bookingRange {
                if let bookDate = Date.getBookDate(for: day) {
                    dates.append(bookDate)
                }
            }
        }
        return dates
    }
  
    static var thisYear: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let component = formatter.string(from: Date())

        if let value = Int(component) {
            return value
        }
        return 0
    }

    private static func getComponent(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "id_ID")
        let component = formatter.string(from: date)
        return component
    }

    private static func getBookDate(for day: Int) -> BookDate? {
        let dateComponent = DateComponents(day: day)
        guard let date = Calendar.current.date(byAdding: dateComponent, to: Date()) else { return nil }
        return BookDate(
            day: getComponent(date: date, format: "EEE"),
            dayNumber: getComponent(date: date, format: "dd"),
            month: getComponent(date: date, format: "MM"),
            year: getComponent(date: date, format: "yyyy")
        )
    }

    static func convertDateFormater(date: Date) -> String {
        let dateString = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        guard let date = dateFormatter.date(from: dateString) else { return ""}
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date)
    }

    static func convertDateFormaterWithHour(date: Date) -> String {
        let dateString = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.locale = Locale(identifier: "id_ID")
        guard let date = dateFormatter.date(from: dateString) else { return ""}
        dateFormatter.dateFormat = "dd/MM/yyyy/HH"
        return  dateFormatter.string(from: date)
    }

    static func convertDateFormat(date: Date, format: String) -> String {
        let dateString = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.locale = Locale(identifier: "id_ID")
        guard let date = dateFormatter.date(from: dateString) else { return ""}
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: date)

    }
}
