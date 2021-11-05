//
//  DateExtention.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import Foundation
import SwiftUI

extension Date {

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

    static func getWeek(for month: Int = 1, hari: Int) -> [BookDate] {
        var dates = [BookDate]()
        let calendar = Calendar.current
        if hari < 7 {
            let lastIndex = 7 + (7 - hari)
            for number in 0...lastIndex {
                    guard let fullDate = calendar.date(byAdding: DateComponents(day: number), to: Date()) else { continue }
                    let day = getComponent(date: fullDate, format: "EEE")
                    let dayNumber = getComponent(date: fullDate, format: "dd")
                    let month = getComponent(date: fullDate, format: "MM")
                    let year = getComponent(date: fullDate, format: "yyyy")
                    let bookDate = BookDate(day: day, dayNumber: dayNumber, month: month, year: year)
                    dates.append(bookDate)
                }
        }else {
            for number in 0...7 {
                    guard let fullDate = calendar.date(byAdding: DateComponents(day: number), to: Date()) else { continue }
                    let day = getComponent(date: fullDate, format: "EEE")
                    let dayNumber = getComponent(date: fullDate, format: "dd")
                    let month = getComponent(date: fullDate, format: "MM")
                    let year = getComponent(date: fullDate, format: "yyyy")
                    let bookDate = BookDate(day: day, dayNumber: dayNumber, month: month, year: year)
                    dates.append(bookDate)
                }
        }
        return dates

    }

    static func convertDateFormater(date: Date) -> String {
            let dateString = "\(date)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            guard let date = dateFormatter.date(from: dateString) else { return ""}
            dateFormatter.dateFormat = "dd/MM/yyy"
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
}
