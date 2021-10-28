//
//  PengaturanBengkel.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI

struct motorBrand: Identifiable, Hashable {
    var id: String {name}
    var name: String
}

struct motorcc: Identifiable, Hashable {
    var id: String {ccMotor}
    var ccMotor: String
}
struct selectedBrand {
    var brand: Set<motorBrand>
    var cc: Set<motorcc>
}

let allBrands: [motorBrand] = [motorBrand(name: "Honda"), motorBrand(name: "Yamaha"), motorBrand(name: "Suzuki")]
let allCC: [motorcc] = [motorcc(ccMotor: "110"), motorcc(ccMotor: "125")]

struct PengaturanBengkel: View {
    @State private var date = Date()
    @State private var brandMotor: String = ""
    @State private var ccMotor: String = ""
    @State private var isBrandSelected: Bool = false
    @State private var isCCSelected: Bool = false
    @State private var isAddMekanik: Bool = false
    var dayInAWeek: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    @State var daySelected: [Bool] = [true, true, true, true, true, true, true]
    @State var task = selectedBrand(brand: [], cc: [])
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("BRAND MOTOR YANG BISA DIPERBAIKI")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        MultiSelector(options: allBrands,
                                      optionToString: { $0.name },
                                      selected: $task.brand
                        )
                            .frame(width: .infinity, height: 40)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)

                    }
                    VStack(spacing: 8) {
                        Text("CC MOTOR YANG BISA DIPERBAIKI")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        MultiSelector(options: allCC,
                                      optionToString: { $0.ccMotor },
                                      selected: $task.cc
                        )
                            .frame(width: .infinity, height: 40)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)
                    }
                    VStack(spacing: 8) {
                        Text("HARI OPERASIONAL")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        HStack {
                            ForEach(0..<dayInAWeek.count) { indexDay in
                                Text("\(dayInAWeek[indexDay])")
                                    .padding(.all, 7)
                                    .background(self.daySelected[indexDay] == true ? Color(hex: "EB6424") : Color(hex: "D2CFCF"))
                                    .cornerRadius(8)
                                    .foregroundColor(self.daySelected[indexDay] == true ? Color.white : Color.gray)
                                    .onTapGesture {
                                        if self.daySelected[indexDay] == true {
                                            daySelected[indexDay] = false
                                        } else {
                                            daySelected[indexDay] = true
                                        }
                                    }
                            }
                        }
                    }
                    .frame(width: .infinity)
                    VStack(spacing: 8) {
                        Text("JAM OPERASIONAL")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        DatePicker(
                            "Start Day",
                            selection: $date,
                            displayedComponents: .hourAndMinute
                        )
                        DatePicker(
                            "End Day",
                            selection: $date,
                            displayedComponents: .hourAndMinute
                        )
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("MEKANIK")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        Button(action: {
                            self.isAddMekanik.toggle()
                        }) {
                            Text("+Tambah Mekanik")
                                .font(Font.system(size: 13, weight: .regular))
                                .foregroundColor(Color("PrimaryColor"))
                                .frame(width: proxy.size.width, alignment: .leading)
                        }
                        .sheet(isPresented: $isAddMekanik) {
                            addMekanik(showSheetView: self.$isAddMekanik)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: addMekanik( showSheetView: $isAddMekanik)) {
                        Text("Lanjutkan")
                            .padding(.vertical, 8)
                            .frame(width: proxy.size.width * 0.8, alignment: .center)
                            .background(Color("PrimaryColor"))
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
    }
}

struct PengaturanBengkel_Previews: PreviewProvider {
    static var previews: some View {
        PengaturanBengkel()
    }
}
