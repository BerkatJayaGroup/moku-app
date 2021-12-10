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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var bengkelName: String = ""
    @State var tabSelection: CustomerView.Tab = .bengkel

    @State var showInfoModalView: Bool = false
    @Binding var isBackToRoot: Bool
    @Binding var tab: CustomerView.Tab

    init(orderId: DocumentReference?, bengkelName: String, tab: Binding<CustomerView.Tab>, isBackToRoot: Binding<Bool>) {
        self._tab = tab
        self._isBackToRoot = isBackToRoot
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
                    Button {
                        NavigateToRootView.popToRootView()
                    } label: {
                        Text("Pindah ke Halaman Booking")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(8)
                    }
                    Button {
                        showInfoModalView = true
                    } label: {
                         Text("Batalkan Booking")
                            .fontWeight(.semibold)
                            .foregroundColor(AppColor.primaryColor)
                            .padding(.vertical, 16)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .background(AppColor.salmonOrange)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showInfoModalView, onDismiss: {
                        NavigateToRootView.popToRootView()
                    }, content: {
                        CancelBookingModal(order: order, activeFrom: true)
                    })

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
                    Button {
                        NavigateToRootView.popToRootView()
                    } label: {
                        Text("Pilih Bengkel Lain")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(8)
                    }

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
                    Button {
                        NavigateToRootView.popToRootView()
                    } label: {
                        Text("Pindah ke halaman booking")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(8)
                    }
                default:
                    Text("Tidak ada booking")
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
