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
    private let tggl = [true, false, true, true, false, true, false]

    @StateObject private var viewModel: ViewModel

    init(bengkel: Bengkel, typeOfService: Order.Service, isRootActive: Binding<Bool>, isHideTabBar: Binding<Bool>) {
        let viewModel = ViewModel(bengkel: bengkel, typeOfService: typeOfService)
        _viewModel = StateObject(wrappedValue: viewModel)
        _isRootActive = isRootActive
        _isHideTabBar = isHideTabBar
    }

    @Binding var isRootActive: Bool

    @Binding var isHideTabBar: Bool

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
                CustomTextField.init(placeholder: "Deskripsikan keluhan yang kamu rasakan di motormu disini ya", text: $viewModel.text)
                    .font(.body)
                    .background(Color(UIColor.systemGray6))
                    .accentColor(.green)
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()

            if let order = viewModel.order {
                NavigationLink(destination: BookingSummary(order: order, isRootActive: self.$isRootActive, isHideTabBar: self.$isHideTabBar), isActive: $viewModel.isActive) {
                    EmptyView()
                }
            }

            Button {
                if viewModel.hour != 0 && viewModel.selectedDate != BookDate.default {
                    let tggl = DateComponents(timeZone: TimeZone(identifier: TimeZone.current.identifier), year: Int(viewModel.selectedDate.year), month: Int(viewModel.selectedDate.month), day: Int(viewModel.selectedDate.dayNumber), hour: viewModel.hour)
                    viewModel.schedule = Calendar.current.date(from: tggl) ?? Date()
                    if let selectedMotor = SessionService.shared.selectedMotor {
                        viewModel.order = Order(bengkelId: viewModel.bengkel.id, customerId: viewModel.userId, motor: selectedMotor, typeOfService: viewModel.typeOfService, notes: viewModel.text, schedule: viewModel.schedule)
                    }
                    print("apa aja dah")
                } else {
                    // alert
                print("apa aja dah else")
                }
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
                let arr = convert(hari: viewModel.bengkel.operationalDays)
                let count = arr.filter({ $0 != ""}).count
                let dates = Date.getWeek(day: count)
                let filtered = dates.filter {arr.contains($0.day)}
                HStack {
                    ForEach(filtered, id: \.dayNumber) { date in
                        DateStack(date: date, isSelected: viewModel.selectedDate.dayNumber == date.dayNumber, onSelect: { selectedDate in
                            viewModel.selectedDate = selectedDate
                            viewModel.selectedHourndex = -1
                            viewModel.hour = 0
                        })
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
