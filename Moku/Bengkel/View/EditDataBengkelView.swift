//
//  SuntingDataBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import SwiftUI

struct EditDataBengkelView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var showSheetOpen = false
    @State var showSheetClose = false
    @State var isSubmitting: Bool = false
    var dayInAWeek: [String] = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    @StateObject var viewModel: ViewModel

    init(bengkel: Bengkel) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack{
            GeometryReader { proxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("BRAND MOTOR YANG BISA DIPERBAIKI")
                                .font(Font.system(size: 11, weight: .regular))
                                .frame(width: proxy.size.width, alignment: .leading)
                            MultiSelector(options: allBrands,
                                          optionToString: { $0.rawValue }, barTitle: "Brand", proxy: proxy,
                                          selected: $viewModel.selectedBrand
                            )
                            brandEmptyAlert(for: $viewModel.selectedBrand, alert: "Brand motor harus diisi")
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
                            HStack {
                                Text("Jam Buka")
                                Spacer()
                                Button {
                                    self.showSheetOpen = true
                                }label: {
                                    if viewModel.openHours < 10 {
                                        Text("0\(viewModel.openHours):00")
                                            .font(.system(size: 17))
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(AppColor.textField)
                                            .cornerRadius(8)
                                    } else {
                                        Text("\(viewModel.openHours):00")
                                            .font(.system(size: 17))
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(AppColor.textField)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            HStack {
                                Text("Jam Tutup")
                                Spacer()
                                Button {
                                    self.showSheetClose = true
                                } label: {
                                    if viewModel.closeHours < 10 {
                                        Text("0\(viewModel.closeHours):00")
                                            .font(.system(size: 17))
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(AppColor.textField)
                                            .cornerRadius(8)
                                    } else {
                                        Text("\(viewModel.closeHours):00")
                                            .font(.system(size: 17))
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(AppColor.textField)
                                            .cornerRadius(8)
                                    }
                                }
                            }
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
                        viewModel.updateBengkel()
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
            .blur(radius: $showSheetOpen.wrappedValue || $showSheetClose.wrappedValue ? 1 : 0 )
            .overlay(
                $showSheetOpen.wrappedValue || $showSheetClose.wrappedValue ? Color.black.opacity(0.6) : nil
                )
            if self.showSheetOpen == true {
                GeometryReader { proxy in
                    VStack {
                        Picker("", selection: $viewModel.openHours) {
                                ForEach(0..<24) { i in
                                    if i < 10 {
                                        Text("0\(i):00")
                                    } else {
                                        Text("\(i):00")
                                    }
                                }
                            }.labelsHidden()
                            .frame(maxWidth: proxy.size.width  - 90)
                            .pickerStyle(WheelPickerStyle())
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color.white).shadow(radius: 1))

                        VStack {
                            Button {
                                self.showSheetOpen = false
                            }label: {
                                Text("Done")
                                    .foregroundColor(AppColor.primaryColor)
                                    .fontWeight(Font.Weight.bold)
                                    .padding(.vertical)
                                    .frame(maxWidth: proxy.size.width  - 90)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(Color.white).shadow(radius: 1))
                            }.padding()
                        }
                    }.position(x: proxy.size.width / 2, y: proxy.size.height - 200)
                }
            }

            if self.showSheetClose == true {
                GeometryReader { proxy in
                    VStack {
                            Picker("", selection: $viewModel.closeHours) {
                                ForEach(0..<24) { i in
                                    if i < 10 {
                                        Text("0\(i):00")
                                    } else {
                                        Text("\(i):00")
                                    }
                                }
                            }.labelsHidden()
                            .frame(maxWidth: proxy.size.width  - 90)
                            .pickerStyle(WheelPickerStyle())
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color.white).shadow(radius: 1))

                        VStack {
                            Button {
                                self.showSheetClose = false
                            }label: {
                                Text("Done")
                                    .foregroundColor(AppColor.primaryColor)
                                    .fontWeight(Font.Weight.bold)
                                    .padding(.vertical)
                                    .frame(maxWidth: proxy.size.width  - 90)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(Color.white).shadow(radius: 1))
                            }.padding()
                        }
                    }.position(x: proxy.size.width / 2, y: proxy.size.height - 200)
                }
            }
        }
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
