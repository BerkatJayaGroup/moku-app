//
//  CancelBookingModal.swift
//  Moku
//
//  Created by Devin Winardi on 09/11/21.
//

import SwiftUI

struct CancelBookingModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var orderCustomerViewModel: OrderCustomerViewModel = .shared

    @State var order: Order
    @State var activeFrom: Bool
    @State var showingAlert = false
    @State var isCancel = false

    var alasans: [Order.CancelingReason] = [.bengkelTutup, .bengkelLain, .tidakJadi, .ubahOrder]

    @State var selection: Order.CancelingReason?
    @State var isActive: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                List(alasans, id: \.self, selection: $selection) { alasan in
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
                }
                .padding()
                .navigationBarTitle(Text("Pilih alasan membatalkan booking").font(.headline), displayMode: .inline)
                .listStyle(.plain)

                Button("Selesai") {

                    let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: order.schedule)
                    let now = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
                    if oneHourAgo != now {
                        showingAlert = true
                        isCancel = true
                    } else {
                        showingAlert = true
                        isCancel = false
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
                                }

                                orderCustomerViewModel.cancelBooking(order: order, reason: selection)
                            }
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, secondaryButton: .cancel())
                }
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
