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
                NavigationLink(destination: BengkelTabItem(), isActive: $isActive) {
                    EmptyView()
                }

                Button("Selesai") {
                    if let selection = selection {
                        isActive = true
                        orderCustomerViewModel.cancelBooking(order: order, reason: selection)
                    }
                }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .padding(.horizontal)
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
