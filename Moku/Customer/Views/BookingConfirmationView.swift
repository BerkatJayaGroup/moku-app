//
//  BookingConfirmation.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 02/11/21.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import Introspect

struct BookingConfirmationView: View {
    @ObservedObject var orderCustomerViewModel: OrderCustomerViewModel = .shared
    var bengkelName: String = ""
    
    @State var showInfoModalView: Bool = false
    
    @Binding var isRootActive: Bool
    @Binding var isHideTabBar: Bool
    
    init(orderId: DocumentReference?, bengkelName: String, isRootActive: Binding<Bool>, isHideTabBar: Binding<Bool>) {
        _isRootActive = isRootActive
        _isHideTabBar = isHideTabBar
        if let id = orderId {
            orderCustomerViewModel.getCustomerOrder(docRef: id)
        }
        self.bengkelName = bengkelName
    }

    var body: some View {
        VStack {
            Text(bengkelName).font(.headline).padding(.top)
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
                        self.isRootActive = false
                        self.isHideTabBar = false
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)
                    Button("Batalkan Booking", action: {
                        showInfoModalView = true
//                        orderCustomerViewModel.cancelBooking(order: order)
                    })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SalmonOrange"))
                        .foregroundColor(Color("PrimaryColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)
                        .sheet(isPresented: $showInfoModalView) {
                              CancelBookingModal()
                        }

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
                        self.isRootActive = false
                        self.isHideTabBar = false
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
                        self.isRootActive = false
                        self.isHideTabBar = false
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
        }.navigationBarHidden(true)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
        }
        
    }
}

// struct BookingConfirmation_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingConfirmationView()
//    }
// }
