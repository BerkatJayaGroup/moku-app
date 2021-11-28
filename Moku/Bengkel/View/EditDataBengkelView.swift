//
//  SuntingDataBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import SwiftUI

struct EditDataBengkelView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var isSubmitting: Bool = false
    @State var openTime = Date()
    @State var closeTime = Date()
    var dayInAWeek: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    @StateObject var viewModel: ViewModel
    
    
    init(bengkel: Bengkel) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        GeometryReader { proxy in
            VStack{
                ScrollView() {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("BRAND MOTOR YANG BISA DIPERBAIKI")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        MultiSelector(options: allBrands,
                                      optionToString: { $0.rawValue },
                                      selected: $viewModel.selectedBrand
                        )
                        .frame(width: proxy.size.width, height: 40)
                        .background(Color(hex: "F3F3F3"))
                        .cornerRadius(8)
                        brandEmptyAlert(for: $viewModel.selectedBrand, alert: "Brand motor harus diisi")
                    }
                    .padding(.bottom, 24)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CC MOTOR YANG BISA DIPERBAIKI")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        MultiSelector(options: allCC,
                                      optionToString: { $0.ccMotor },
                                      selected: $viewModel.selectedCC
                        )
                            .frame(width: proxy.size.width, height: 40)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)
                        ccEmptyAlert(for: $viewModel.selectedCC, alert: "CC motor harus diisi")
                    }
                    .padding(.bottom, 24)
                    VStack(spacing: 8) {
                        Text("HARI OPERASIONAL")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        HStack {
                            ForEach(0..<dayInAWeek.count) { indexDay in
                                Text("\(dayInAWeek[indexDay])")
                                    .padding(.all, 7)
                                    .background(viewModel.daySelected[indexDay] == true ? Color(hex: "EB6424") : Color(hex: "D2CFCF"))
                                    .cornerRadius(8)
                                    .foregroundColor(viewModel.daySelected[indexDay] == true ? Color.white : Color.gray)
                                    .onTapGesture {
                                        if viewModel.daySelected[indexDay] == true {
                                            viewModel.daySelected[indexDay] = false
                                        } else {
                                            viewModel.daySelected[indexDay] = true
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                    .frame(width: proxy.size.width)
                    VStack(spacing: 8) {
                        Text("JAM OPERASIONAL")
                            .font(Font.system(size: 11, weight: .regular))
                            .frame(width: proxy.size.width, alignment: .leading)
                        DatePicker(
                            "Start Day",
                            selection: $closeTime,
                            displayedComponents: .hourAndMinute
                        )
                        DatePicker(
                            "End Day",
                            selection: $closeTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                    .padding(.bottom, 24)
                    Divider()
                    Text("Masukkan kisaran harga jasa service rutin. Harga yang Anda masukkan akan dijadikan sebagai pertimbangan dan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.bottom, 24)
                    HStack {
                        TextField("Rp minimum", text: $viewModel.minPrice)
                            .font(.system(size: 15))
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(9)
                            .keyboardType(.numberPad)
                        Text("-")
                        TextField("Rp maksimum", text: $viewModel.maxPrice)
                            .font(.system(size: 15))
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(9)
                            .keyboardType(.numberPad)
                    }.padding()
                }
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Simpan")
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(AppColor.primaryColor)
                    .cornerRadius(8)
                    .frame(width: 309)
                }
            }
        }
        .padding()
        .navigationBarTitle("Pengaturan", displayMode: .inline)
    }
    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, isSubmitting {
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
}
