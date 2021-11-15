//
//  PengaturanBengkel.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI
import Combine
import SwiftUIX

struct MotorBrand: Identifiable, Hashable {
    var id: String {name}
    var name: String
}

struct Motorcc: Identifiable, Hashable {
    var id: String {ccMotor}
    var ccMotor: String
}

struct SelectedBrand {
    var brand: Set<Brand>
    var cc: Set<Motorcc>
}

let allBrands: [Brand] = [Brand.honda, Brand.yamaha, Brand.kawasaki, Brand.suzuki]
let allCC: [Motorcc] = [Motorcc(ccMotor: "110"), Motorcc(ccMotor: "125")]

struct PengaturanBengkel: View {
    var bengkelOwnerForm: BengkelOwnerOnboardingView
    @State var openTime = Date()
    @State var closeTime = Date()
    @State var brandMotor: String = ""
    @State var ccMotor: String = ""
    @State var isBrandSelected: Bool = false
    @State var isCCSelected: Bool = false
    @State var isAddMekanik: Bool = false
    @State var isSubmitting: Bool = false
    var dayInAWeek: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    @State var daySelected: [Bool] = [true, true, true, true, true, true, true]
    @State var selectedBrand = Set<Brand>()
    @State var selectedCC = Set<Motorcc>()
    @State var mechanics = [CalonMekanik]()
    @State var canSubmit = false
    
    var isFormValid: Bool {
        !selectedBrand.isEmpty && !selectedCC.isEmpty && !mechanics.isEmpty
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("BRAND MOTOR YANG BISA DIPERBAIKI")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    MultiSelector(options: allBrands,
                                  optionToString: { $0.rawValue },
                                  selected: $selectedBrand
                    )
                    .frame(width: proxy.size.width, height: 40)
                    .background(Color(hex: "F3F3F3"))
                    .cornerRadius(8)
                    brandEmptyAlert(for: $selectedBrand, alert: "Brand motor harus diisi")
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("CC MOTOR YANG BISA DIPERBAIKI")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    MultiSelector(options: allCC,
                                  optionToString: { $0.ccMotor },
                                  selected: $selectedCC
                    )
                        .frame(width: proxy.size.width, height: 40)
                        .background(Color(hex: "F3F3F3"))
                        .cornerRadius(8)
                    ccEmptyAlert(for: $selectedCC, alert: "CC motor harus diisi")
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
                .frame(width: proxy.size.width)
                VStack(spacing: 8) {
                    Text("JAM OPERASIONAL")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    DatePicker(
                        "Start Day",
                        selection: $openTime,
                        displayedComponents: .hourAndMinute
                    )
                    DatePicker(
                        "End Day",
                        selection: $closeTime,
                        displayedComponents: .hourAndMinute
                    )
                }
                Text("MEKANIK")
                    .font(Font.system(size: 11, weight: .regular))
                    .frame(width: proxy.size.width, alignment: .leading)
                if !mechanics.isEmpty {
                    List {
                        ForEach(mechanics) { mech in
                            HStack {
                                Text(mech.name)
                                Spacer()
                            }
                        }.onDelete(perform: deleteItem)
                    }
                    Divider()
                }
                Button {
                    self.isAddMekanik.toggle()
                    print($mechanics.count)
                } label: {
                    Text("+Tambah Mekanik")
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(Color("PrimaryColor"))
                        .frame(width: proxy.size.width, alignment: .leading)
                }
                .sheet(isPresented: $isAddMekanik) {
                    AddMekanik(showSheetView: self.$isAddMekanik, mechanics: $mechanics)
                }
                mekanikEmptyAlert(for: $mechanics, alert: "Mekanik harus diisi")
                Spacer()
                submitButton(proxy: proxy)
            }
        }
        .padding()
        .navigationBarTitle("Pengaturan Bengkel", displayMode: .inline)
    }

    private func deleteItem(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            mechanics.remove(at: index)
        }
    }
    
    @ViewBuilder
    private func submitButton(proxy: GeometryProxy) -> some View {
        NavigationLink(destination: PengaturanHargaBengkel(bengkelOwnerFormViewModel: bengkelOwnerForm.viewModel, pengaturanBengkelForm: self), isActive: $canSubmit) {EmptyView()}

        Button {
            validateForm()
        } label: {
            HStack {
                Spacer()
                Text("Lanjutkan")
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(AppColor.primaryColor)
            .cornerRadius(8)
            .frame(width: (proxy.size.width * 0.9))
        }
    }
    
    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }
    
    @ViewBuilder
    private func mekanikEmptyAlert(for text: Binding<Array<CalonMekanik>>, alert: String) -> some View {
        if text.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }
    
    @ViewBuilder
    private func brandEmptyAlert(for text: Binding<Set<Brand>>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }
    
    @ViewBuilder
    private func ccEmptyAlert(for text: Binding<Set<Motorcc>>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }
    
    func validateForm(){
        isSubmitting = true
        if isFormValid {
            canSubmit = true
        }
    }
}
