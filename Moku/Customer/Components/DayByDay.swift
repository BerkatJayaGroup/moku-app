//
//  DayByDay.swift
//  Moku
//
//  Created by Mac-albert on 02/11/21.
//

import SwiftUI

struct DayByDay: View {
    var day: String
    var time: String
    var isToday: Bool {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let dayToday: String = dateFormatter.string(from: date)
        if dayToday == day {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundColor(isToday == true ? AppColor.primaryColor : .gray)
            VStack {
                Text(day)
                    .font(.system(size: 15))
                    .foregroundColor(isToday == true ? .primary : .gray)
                Text(time)
                    .font(.system(size: 13))
                    .foregroundColor(isToday == true ? .primary : .gray)
            }
            Spacer()
        }
    }
}

struct DayByDay_Previews: PreviewProvider {
    static var previews: some View {
        DayByDay(day: "Senin", time: "10.00-17.00")
    }
}
