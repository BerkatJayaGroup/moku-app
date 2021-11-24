//
//  SheetView.swift
//  Moku
//
//  Created by Mac-albert on 02/11/21.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var dayInAWeek: [String] = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"]
    var dayInAWeek2: [String] = ["Sabtu", "Minggu"]
    var isToday: Bool = false
    var bengkelRepository: BengkelRepository = .shared
    var mainInfo: String
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("Jam Buka")
                        .font(.headline)
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack(spacing: 8) {
                        ForEach(dayInAWeek, id: \.self) { dayIndex in
                            DayByDay(day: dayIndex, time: mainInfo)
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(dayInAWeek2, id: \.self) { dayIndex in
                            DayByDay(day: dayIndex, time: mainInfo)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .frame(height: 320)
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(mainInfo: "10.00-17.00")
    }
}
