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
let allCC: [Motorcc] = [Motorcc(ccMotor: "100"), Motorcc(ccMotor: "110"), Motorcc(ccMotor: "150"), Motorcc(ccMotor: "155"), Motorcc(ccMotor: "175"), Motorcc(ccMotor: "200"), Motorcc(ccMotor: "250"), Motorcc(ccMotor: "500"), Motorcc(ccMotor: "600"), Motorcc(ccMotor: "750"), Motorcc(ccMotor: "1000")]

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
        !selectedBrand.isEmpty && !selectedCC.isEmpty && !mechanics.isEmpty && !daySelected.allSatisfy({$0 == false})
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("BRAND MOTOR YANG BISA DIPERBAIKI")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    MultiSelector(options: allBrands,
                                  optionToString: { $0.rawValue }, barTitle: "Brand", proxy: proxy,
                                  selected: $selectedBrand
                    )
                    brandEmptyAlert(for: $selectedBrand, alert: "Brand motor harus diisi")
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("CC MOTOR YANG BISA DIPERBAIKI")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    MultiSelector(options: allCC,
                                  optionToString: { $0.ccMotor }, barTitle: "Volume Langkah", proxy: proxy,
                                  selected: $selectedCC
                    )
                    ccEmptyAlert(for: $selectedCC, alert: "CC motor harus diisi")
                }
                VStack(alignment: .leading, spacing: 8) {
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
                   dayEmptyAlert(for: $daySelected, alert: "Hari harus dipilih")
                }
                .frame(width: proxy.size.width)
                VStack(alignment: .leading, spacing: 8) {
                    Text("JAM OPERASIONAL")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                    DatePicker(
                        "Jam Buka",
                        selection: $openTime,
                        displayedComponents: .hourAndMinute
                    )
                    DatePicker(
                        "Jam Tutup",
                        selection: $closeTime,
                        displayedComponents: .hourAndMinute
                    )
                    Text("MEKANIK")
                        .font(Font.system(size: 11, weight: .regular))
                        .frame(width: proxy.size.width, alignment: .leading)
                        .padding(.top, 5)

                    if !mechanics.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(mechanics, id: \.self) { (mech) in
                                Text(mech.name).frame(width: proxy.size.width, alignment: .leading)
                                Divider()
                                    .background(Color("DarkGray"))
                            }.onDelete(perform: self.deleteItem)
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
                        AddMekanik(showSheetView: $isAddMekanik, mechanics: $mechanics)
                    }
                    mekanikEmptyAlert(for: $mechanics, alert: "Mekanik harus diisi")
                }
                Spacer()
                submitButton(proxy: proxy)
            }
            .onTapGesture {
                dismissKeyboard()
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
        NavigationLink(
            destination: PengaturanHargaBengkelView(bengkelOwnerFormViewModel: bengkelOwnerForm.viewModel, pengaturanBengkelForm: self),
            isActive: $canSubmit
        ) { EmptyView() }

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
    private func mekanikEmptyAlert(for text: Binding<[CalonMekanik]>, alert: String) -> some View {
        if text.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }

    @ViewBuilder
    private func dayEmptyAlert(for text: Binding<[Bool]>, alert: String) -> some View {
        if daySelected.allSatisfy({ $0 == false }) {
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

    func validateForm() {
        isSubmitting = true
        if isFormValid {
            canSubmit = true
        }
    }
}

struct PengaturanBengkel_Previews: PreviewProvider {
    static var previews: some View {
        PengaturanBengkel(bengkelOwnerForm: BengkelOwnerOnboardingView())
    }
}
