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
    @State private var selectedDate: BookDate = BookDate.default
    @State private var selectedHourndex: Int = -1
    private let tggl = [true, false, true, true, false, true, false]
    @State var bengkel: Bengkel
    @State private var hour = 0
    @State var typeOfService: Order.Service
    @State var schedule = Date()
    @State private var text = ""
    @State private var userId = ""

    @ObservedObject var viewModel = ViewModel()

    init(typeOfService: Order.Service, bengkel: Bengkel) {
        _typeOfService = State(wrappedValue: typeOfService)
        _bengkel = State(wrappedValue: bengkel)
        if let uid = Auth.auth().currentUser?.uid {
            userId = uid
        }
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
                CustomTextField.init(placeholder: "Deskripsikan keluhan yang kamu rasakan di motormu disini ya", text: $text)
                    .font(.body)
                    .background(Color(UIColor.systemGray6))
                    .accentColor(.green)
                    .frame(height: 200)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()

            if let order = viewModel.order {
                NavigationLink(destination: BookingSummary(order: order), isActive: $viewModel.isActive) {
                    EmptyView()
                }
            }

            Button {
                if hour != 0 && selectedDate != BookDate.default {
                    let tggl = DateComponents(timeZone: TimeZone(identifier: TimeZone.current.identifier), year: Int(self.selectedDate.year), month: Int(self.selectedDate.month), day: Int(self.selectedDate.dayNumber), hour: hour)
                    self.schedule = Calendar.current.date(from: tggl) ?? Date()
                    if let selectedMotor = SessionService.shared.selectedMotor {
                        viewModel.order = Order(bengkelId: bengkel.id, customerId: userId, motor: selectedMotor, typeOfService: typeOfService, notes: text, schedule: schedule)

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
                let arr = convert(hari: bengkel.operationalDays)
                let count = arr.filter({ $0 != ""}).count
                let dates = Date.getWeek(hari: count)
                let filtered = dates.filter {arr.contains($0.day)}
                HStack {
                    ForEach(filtered, id: \.dayNumber) { date in
                        DateStack(date: date, isSelected: self.selectedDate.dayNumber == date.dayNumber, onSelect: { selectedDate in
                            self.selectedDate = selectedDate
                        })
                    }
                }.padding(.horizontal)
            }
        }
    }
    fileprivate func createTimeView() -> some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(bengkel.operationalHours.open..<bengkel.operationalHours.close, id: \.self) { item in
                    TimeStack(index: item, isSelected: self.selectedHourndex == item, onSelect: { selectedIndex in
                        self.selectedHourndex = selectedIndex
                        self.hour = selectedIndex
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

// struct BengkelDate_Previews: PreviewProvider {
//    static var previews: some View {
//        BengkelDate(typeOfService: , Bengkel(owner: .init(name: "dicky", phoneNumber: "323", email: "ddsa"), name: "3232", phoneNumber: "00", location: Location(name: "dsds", address: "dsds", longitude: 2.32, latitude: 4.21), operationalHours: .init(open: 2, close: 22), minPrice: "8", maxPrice: "9"))
//    }
// }

extension BengkelDate {

    class ViewModel: ObservableObject {
        @Published var isActive = false

        @Published var order: Order?

        private var subscription = Set<AnyCancellable>()

        init() {
            $order.sink { order in
                self.isActive = order != nil
            }.store(in: &subscription)
        }

    }

}
