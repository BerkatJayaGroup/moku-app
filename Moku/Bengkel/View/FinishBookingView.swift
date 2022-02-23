//
//  ServiceInformationView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/11/21.
//

import SwiftUI
import PhotosUI

struct FinishBookingView: View {

    @StateObject var viewModel: FinishBookingViewModel
    @State private var spareParts: [String] = []
    @State private var notes = ""
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldPresentSparepartsSheet = false
    @State private var bills: [UIImage] = []

    init(order: Order) {
        let viewModel = FinishBookingViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    VStack(alignment: .leading) {
                        Text(viewModel.motorName)
                            .font(.system(size: 22, weight: .semibold))
                        Text(viewModel.customer?.name ?? "")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                        Divider()
                    }
                    .padding(.horizontal, -17)
                    .padding(.top, -10)
                    Section(header: header(title: "Suku Cadang yang diganti")) {
                        Text("+ Tambah Suku Cadang")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColor.primaryColor)
                            .onTapGesture {
                                self.shouldPresentSparepartsSheet.toggle()
                            }
                        VStack {
                            HStack {
                                if spareParts.isEmpty {
                                    Text("Tekan tambah suku cadang untuk menambah suku cadang yang diganti")
                                } else {
                                    Text(spareParts.joined(separator: "\n"))
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding()
                        .background(AppColor.textField)
                        .cornerRadius(5)
                        .frame(minWidth: 0,
                               maxWidth: .infinity, minHeight: 200)
                    }
                    .listRowInsets(EdgeInsets())
                    .textCase(nil)
                    textField(title: "Keterangan Pengerjaan", placeholder: "Deskripsikan kerjaan yang kamu kerjakan pada motor pelanggan", text: $notes, alert: "Harus diisi", isSparePart: false)
                    Section(header: header(title: "Foto Nota dan Bukti Pengerjaan")) {
                        if bills != [] {
                            ScrollView(.horizontal) {
                                HStack {
                                    VStack {
                                        Text("+").font(.system(size: 30))
                                            .foregroundColor(AppColor.primaryColor)
                                        Text("Tambah Foto")
                                            .font(.system(size: 15))
                                            .foregroundColor(AppColor.primaryColor)
                                            .padding(.bottom, 20)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(AppColor.textField)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        self.shouldPresentActionScheet = true
                                    }
                                    ForEach(bills, id: \.self) { image in
                                        Image.init(uiImage: image)
                                            .resizable()
                                            .frame(width: 100, height: 100, alignment: .center)
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        } else {
                            VStack {
                                Text("+").font(.system(size: 40))
                                    .foregroundColor(AppColor.primaryColor)
                                Text("Tambah Foto")
                                    .foregroundColor(AppColor.primaryColor)
                                    .padding(.bottom, 20)
                            }
                            .frame(width: 150, height: 100)
                            .background(AppColor.textField)
                            .cornerRadius(10)
                            .onTapGesture {
                                self.shouldPresentActionScheet = true
                            }
                        }
                    }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .sheet(isPresented: $shouldPresentImagePicker) {
                        if !self.shouldPresentCamera {
                            ImagePHPicker(pickerResult: $bills, isPresented: $shouldPresentImagePicker)
                        } else {
                            ImagePicker(sourceType: .camera, pickerResult: $bills)
                        }
                    }.actionSheet(isPresented: $shouldPresentActionScheet) {
                        ActionSheet(
                            title: Text("Pilih Metode"),
                            message: Text("Mohon pilih metode pengambilan gambar untuk foto profil"),
                            buttons: [
                                .default(Text("Kamera")) {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = true
                                },
                                .default(Text("Ambil dari galeri")) {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = false
                                },
                                .cancel(Text("Batal"))
                            ]
                        )
                    }
                    Button {
                        var order = viewModel.order
                        order.spareparts = spareParts
                        order.status = .done
                        order.serviceNotes = notes
                        viewModel.updateOrder(order: order)
                        NavigateToRootView.popToRootView()
                    } label: {
                        Text("Kirim")
                            .frame(width: 320, height: 45, alignment: .center)
                            .foregroundColor(.white)
                            .background(AppColor.primaryColor)
                            .cornerRadius(8)
                    }
                }
                .background(.white)
                .sheet(isPresented: $shouldPresentSparepartsSheet) {
                    SparepartsListView(chosenSpareparts: $spareParts)
                        .accentColor(.white)
                }
                .navigationTitle("Pesanan Selesai")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button {
                    NavigateToRootView.popToRootView()
                } label: {
                    Text("Kembali")
                        .foregroundColor(.white)
                })
            }
            .onTapGesture {
                endTextEditing()
            }
        }
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        alert: String,
        keyboardType: UIKeyboardType = .default,
        isSparePart: Bool
    ) -> some View {
        Section(header: header(title: title)) {
            if isSparePart {
                Text("+ Tambah Suku Cadang")
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.darkOrange)
                    .onTapGesture {
                        self.shouldPresentSparepartsSheet.toggle()
                    }
            }
            VStack(alignment: .trailing) {
                TextEditor(text: text)
                    .background(AppColor.lightGray)
                    .frame(minHeight: 100)
                    .cornerRadius(5)
                emptyAlert(for: text, alert: alert)
            }
        }
        .textCase(nil)
        .listRowInsets(EdgeInsets())
        .padding(.top)
    }

    func header(title: String) -> some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold ))
            .foregroundColor(.black)
    }

    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty {
            Text(alert).alertStyle()
        }
    }
}

struct FinishBookingView_Previews: PreviewProvider {
    static var previews: some View {
        FinishBookingView(order: .preview)
    }
}
