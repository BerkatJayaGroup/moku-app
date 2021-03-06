//
//  BengkelDate.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import FirebaseAuth
import Combine

struct BengkelDate: View {
    @StateObject private var viewModel: ViewModel
    @State var selection: Int?
    @Binding var tab: Tabs
    @Binding var isBackToRoot: Bool

    init(typeOfService: Order.Service, bengkel: Bengkel, tab: Binding<Tabs>, isBackToRoot: Binding<Bool>) {
        let viewModel = ViewModel(bengkel: bengkel, typeOfService: typeOfService)
        _viewModel = StateObject(wrappedValue: viewModel)
        self._tab = tab
        self._isBackToRoot = isBackToRoot
    }

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
                CustomTextField.init(placeholder: "Deskripsikan keluhan motormu atau tulis permintaan ke pihak bengkel", text: $viewModel.text, isEnabled: true)
                    .font(.body)
                    .background(AppColor.lightGray)
                    .accentColor(.green)
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()

            if let order = viewModel.order {
                NavigationLink(destination: BookingSummary(order: order, tab: $tab, isBackToRoot: $isBackToRoot), tag: 1, selection: $selection) {
                    EmptyView()
                }
            }

            Button {
                if viewModel.hour != 0 && viewModel.selectedDate != BookDate.default {
                    let tggl = DateComponents(timeZone: TimeZone(identifier: TimeZone.current.identifier), year: Int(viewModel.selectedDate.year), month: Int(viewModel.selectedDate.month), day: Int(viewModel.selectedDate.dayNumber), hour: viewModel.hour)
                    viewModel.schedule = Calendar.current.date(from: tggl) ?? Date()
                    if let selectedMotor = SessionService.shared.selectedMotor {
                        viewModel.order = Order(bengkelId: viewModel.bengkel.id, customerId: viewModel.userId, motor: selectedMotor, typeOfService: viewModel.typeOfService, notes: viewModel.text, schedule: viewModel.schedule)
                        self.selection = 1
                    }
                } else {
                    print("apa aja dah else")
                }
            } label: {
                Text("Selanjutnya")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(8)
            }.padding(.bottom, 16)
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .padding(.top)
        .navigationTitle("Pesan")
        .navigationBarTitleDisplayMode(.inline)
    }
    fileprivate func createDateView() -> some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                let arr = convert(hari: viewModel.bengkel.operationalDays)
                let count = arr.filter({ $0 != ""}).count
                let dates = Date.getWeek(day: count)
                let filtered = dates.filter {arr.contains($0.day)}
                HStack {
                    ForEach(Array(filtered.enumerated()), id: \.offset) { index, date in
                        if index < 7 {
                            DateStack(date: date, isSelected: viewModel.selectedDate.dayNumber == date.dayNumber, onSelect: { selectedDate in
                                viewModel.selectedDate = selectedDate
                                viewModel.selectedHourndex = -1
                                viewModel.hour = 0
                            })
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
    fileprivate func createTimeView() -> some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.bengkel.operationalHours.open..<viewModel.bengkel.operationalHours.close, id: \.self) { item in
                    TimeStack(index: item, isSelected: viewModel.selectedHourndex == item && viewModel.checkAvailability(index: item) == false, isDisabled: viewModel.checkAvailability(index: item), onSelect: { selectedIndex in
                        viewModel.selectedHourndex = selectedIndex
                        viewModel.hour = selectedIndex
                    })
                }
            }.padding(.horizontal)
        }
    }
    private func convert(hari: [Bool]) -> [String] {
        let week: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
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
