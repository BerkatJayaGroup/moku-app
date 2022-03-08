//
//  SheetView.swift
//  Moku
//
//  Created by Mac-albert on 02/11/21.
//

import SwiftUI

struct SheetView: View {
    var dayInAWeek: [String] = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"]
    var dayInAWeek2: [String] = ["Sabtu", "Minggu"]
    var isToday: Bool = false
    var bengkelRepository: BengkelRepository = .shared
    var mainInfo: String
    var body: some View {
        VStack {
            HStack {
                Text("Jam Buka")
                    .font(.headline)
                Spacer()
            }
            HStack(alignment: .top) {
                VStack(spacing: 8) {
                    ForEach(dayInAWeek, id: \.self) { dayIndex in
                        DayByDay(day: dayIndex, time: mainInfo)
                    }
                }
                VStack(spacing: 8) {
                    ForEach(dayInAWeek2, id: \.self) { dayIndex in
                        DayByDay(day: dayIndex, time: mainInfo)
                    }
                }
            }.padding(.top, 8)
                .padding(.bottom, 48)
        }
        .padding()
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(mainInfo: "10.00-17.00")
    }
}
