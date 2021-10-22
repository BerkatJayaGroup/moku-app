//
//  BengkelDate.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct BengkelDate: View {
    @State private var selectedDate: BookDate = BookDate.default
    @State private var selectedHourndex: Int = -1
    private let dates = Date.getWeek()
    @Binding var date: BookDate
    @Binding var hour: String
    @State private var text = ""
    let columns = [
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10),
        GridItem(.fixed(60), spacing: 10)
    ]
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Pilih Tanggal")
                        .font(.headline)
                        .padding(.horizontal)
                    createDateView()
                    Divider()
                    Text("Pilih Jam")
                        .font(.headline)
                        .padding(.horizontal)
                    createTimeView()
                    Divider()
                    Text("Tambah keterangan kondisi motor")
                        .font(.headline)
                        .padding(.horizontal)
                    CustomTextField.init(placeholder: "Start typing..", text: $text)
                        .font(.body)
                        .background(Color(UIColor.systemGray6))
                        .accentColor(.green)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                Button(action: {}) {
                    Text("Lanjutkan")
                }
                .frame(width: 300, height: 45)
                .background(Color.yellow)
                .cornerRadius(10)
                .padding()
            }
        }
    }
    fileprivate func createDateView() -> some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dates, id: \.day) { date in
                        DateStack(date: date, isSelected: self.selectedDate.day == date.day, onSelect: { selectedDate in
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

                    })
                }
            }.padding(.horizontal)
        }
    }
}

struct BengkelDate_Previews: PreviewProvider {
    static var previews: some View {
        BengkelDate(date: .constant(BookDate.default), hour: .constant(""))
    }
}
