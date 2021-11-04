//
//  BengkelDate.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import simd

struct BengkelDate: View {
    @State private var selectedDate: BookDate = BookDate.default
    @State private var selectedHourndex: Int = -1
    @Binding var date: BookDate
    private let tggl = [true, false, true, true, false, true, false]
    @Binding var hour: String
    @State var schedule = Date()
    @State private var text = ""
    let columns = [
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10)
    ]
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Pilih Tanggal")
                    .font(.headline)
                    .padding(.horizontal)
                VStack(alignment: .center) {
                    createDateView()
                    Divider()
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .padding(.top)
                }.padding(.vertical, 10)
                Text("Pilih Jam")
                    .font(.headline)
                    .padding(.horizontal)
                VStack(alignment: .center) {
                    createTimeView()
                    Divider()
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .padding(.top)
                }.padding(.vertical, 10)
                Text("Tambah keterangan kondisi motor")
                    .font(.headline)
                    .padding(.horizontal)
                CustomTextField.init(placeholder: "Deskripsikan keluhan yang kamu rasakan di motormu disini ya", text: $text)
                    .font(.body)
                    .background(Color(UIColor.systemGray6))
                    .accentColor(.green)
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()
            Button {
            }label: {
                Text("Lanjutkan")
            }
            .frame(width: 300, height: 50)
            .background(Color("PrimaryColor"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Pesan")
        .navigationBarTitleDisplayMode(.inline)
    }
    fileprivate func createDateView() -> some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                let arr = convert(hari: tggl)
                let count = arr.filter({ $0 != ""}).count
                let dates = Date.getWeek(hari: count)
                let filtered = dates.filter {arr.contains($0.day)}
                HStack {
                    ForEach(filtered, id: \.dayNumber) { date in
                        DateStack(date: date, isSelected: self.selectedDate.dayNumber == date.dayNumber, onSelect: { selectedDate in
                            self.selectedDate = selectedDate
                            self.date = selectedDate
                    
                        })
                    }
                }.padding(.horizontal)
            }
        }
    }
    fileprivate func createTimeView() -> some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<10, id: \.self) { item in
                    TimeStack(index: item, isSelected: self.selectedHourndex == item, onSelect: { selectedIndex in
                        self.selectedHourndex = selectedIndex
                        self.hour = "\(selectedIndex):00"
//                        let tggl = DateComponents(timeZone: , year: Int(self.selectedDate.year), month: Int(self.selectedDate.month), day: Int(self.selectedDate.day), hour: selectedIndex)
//                        self.schedule = Calendar.current.date(from: tggl) ?? Date()
                    })
                }
            }.padding(.horizontal)
        }
    }
    private func convert(hari: [Bool]) -> [String] {
        var week: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
        var test: [String] = []
        for i in 0..<hari.count {
            if hari[i] == false {
                test.append("")
            } else {
                test.append(week[i])
            }
        }
        return test
    }
}

struct BengkelDate_Previews: PreviewProvider {
    static var previews: some View {
        BengkelDate(date: .constant(BookDate.default), hour: .constant(""))
    }
}
