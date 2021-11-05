//
//  BookingConfirmation.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 02/11/21.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct BookingConfirmationView: View {
    @ObservedObject var orderCustomerViewModel: OrderCustomerViewModel = .shared

    init(orderId: DocumentReference?) {
        if let id = orderId {
            orderCustomerViewModel.getCustomerOrder(docRef: id)
        }

    }

    var body: some View {
        VStack {
            Text("Berkat Jaya Motor").font(.headline).padding(.top)
            Spacer()
            if let order = orderCustomerViewModel.orderConfirmation {
                switch order.status {
                case .waitingConfirmation:
                    Image("pendingIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Spacer()
                    Text("Menunggu Konfirmasi dari Bengkel")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Silahkan pindah ke halaman booking untuk mengecek status pesanan kamu")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 80)
                    Button("Pindah ke Halaman Booking", action: {
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)
                    Button("Batalkan Booking", action: {
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SalmonOrange"))
                        .foregroundColor(Color("PrimaryColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)

                case .rejected:
                    Image("rejectIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Spacer()
                    Text("Bengkel Telah Menolak Booking Anda")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Maaf, bengkel yang anda pilih menolak bookingan anda, Silahkan pilih bengkel lain.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 80)
                    Button("Pilih Bengkel Lain", action: {
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)

                case .onProgress:
                    Image("acceptIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Spacer()
                    Text("Bengkel Telah Menerima Booking Anda")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Silahkan pindah ke halaman booking untuk melihat detail pesanan kamu")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 80)
                    Button("Pindah ke halaman booking", action: {
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)

                default:
                    Text("Tidak ada booking")
                }
            }
        }
    }
}

// struct BookingConfirmation_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingConfirmationView()
//    }
// }
