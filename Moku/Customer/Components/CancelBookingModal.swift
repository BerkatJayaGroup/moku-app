//
//  CancelBookingModal.swift
//  Moku
//
//  Created by DEVIN WINARDI on 09/11/21.
//

import SwiftUI
import Introspect

struct CancelBookingModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var orderCustomerViewModel: OrderCustomerViewModel = .shared

    @State var order: Order
    @State var activeFrom: Bool
    @State var showingAlert = false
    @State var isCancel = false

    var alasans: [Order.CancelingReason] = [.bengkelLain, .ubahOrder, .alasanLainnya]

    @State var selection: Order.CancelingReason?
    @State var otherReason: String = ""
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            Text("Pilih alasan membatalkan booking")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            ForEach(alasans, id: \.self) { alasan in
                Button { self.selection = alasan
                } label: {
                    HStack {
                        Text(alasan.rawValue).foregroundColor(.black)
                        Spacer()
                        if alasan == selection {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }.padding()
            CustomTextField.init(placeholder: "Deskripsikan alasanmu membatalkan booking disini", text: $otherReason, isEnabled: selection == .alasanLainnya)
                .font(.body)
                .background(AppColor.lightGray)
                .accentColor(.green)
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.horizontal)
            Button {
                let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: order.schedule)
                let now = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
                if oneHourAgo != now {
                    showingAlert = true
                    isCancel = true
                } else {
                    showingAlert = true
                    isCancel = false
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Selesai")
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("PrimaryColor"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal)
            .alert(isPresented: $showingAlert) {
                Alert(title: isCancel ? Text("Booking berhasil dibatalkan"): Text("Booking gagal dibatalkan"), message: isCancel ? Text("Jika ingin menambah booking baru harap melakukan pemesanan ulang.") : Text("Booking sudah tidak dapat dibatalkan karena melewati batas waktu maksimal pembatalan. Harap coba kembali"), primaryButton: .default(Text("OK")) {
                    if isCancel == true {
                        if let selection = selection {
                            if activeFrom == true {
                                isActive = true
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                                NavigateToRootView.popToRootView()
                            }
                            if selection == .alasanLainnya {
                                orderCustomerViewModel.cancelBooking(order: order, reason: otherReason)
                            } else {
                                orderCustomerViewModel.cancelBooking(order: order, reason: selection.rawValue)
                            }
                        }
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                        NavigateToRootView.popToRootView()
                    }
                    self.presentationMode.wrappedValue.dismiss()
                    NavigateToRootView.popToRootView()
                }, secondaryButton: .cancel())
            }
        }
    }
}

//
// struct CancelBookingModal_Previews: PreviewProvider {
//    static var previews: some View {
//        CancelBookingModal()
//    }
// }
