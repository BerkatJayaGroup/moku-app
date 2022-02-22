//
//  DetailBookingView.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import PartialSheet
import SDWebImageSwiftUI
import Introspect

struct DetailBookingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var viewModel: ViewModel

    @State var isShowRejectModal = false
    @State var isShowFinishBookingSheet = false
    @State var uiTabarController: UITabBarController?

    init(order: Order) {
        let viewModel = ViewModel(order: order, showModal: false)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @ViewBuilder
    var waitingConfirmationView: some View {
        Button {
            viewModel.showModal = true
        } label: {
            Text("Terima Booking")
                .frame(width: 310, height: 44)
                .foregroundColor(.white)
                .background(AppColor.primaryColor)
                .cornerRadius(8)
                .frame(width: 320, height: 45, alignment: .center)
        }
        .partialSheet(isPresented: $viewModel.showModal) {
            AssignMechanics(order: viewModel.order, isRootActive: $viewModel.showModal)
        }
        .padding(.bottom, 16)

        Button {
            isShowRejectModal.toggle()
        } label: {
            Text("Tolak Booking")
                .frame(width: 310, height: 44)
                .background(Color(hex: "FFF4E9"))
                .cornerRadius(8)
                .foregroundColor(AppColor.primaryColor)
                .frame(width: 320, height: 45, alignment: .center)
        }.partialSheet(isPresented: $isShowRejectModal) {
            RejectAppointmentModal(order: viewModel.order)
        }
    }

    @ViewBuilder
    var scheduledView: some View {
        if viewModel.order.schedule.get(.day) == Date().get(.day) {
            Button {
                UIApplication.shared.keyWindowPresentedController?.dismiss(animated: true)
                viewModel.updateStatusOrder(status: .onProgress)
            } label: {
                Text("Kerjakan")
                    .frame(width: 310, height: 44)
                    .foregroundColor(.white)
                    .background(AppColor.primaryColor)
                    .cornerRadius(8)
                    .frame(width: 320, height: 45, alignment: .center)
            }
        } else {
            Divider().padding(.bottom, 8)
            HStack {
                Text("Mekanik yang ditugaskan").fontWeight(.semibold)
                Spacer()
            }
            HStack(spacing: 25) {
                if let mechanicPhoto = viewModel.order.mekanik?.photo {
                    WebImage(url: URL(string: mechanicPhoto))
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .imageScale(.large)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle")
                        .frame(width: 80, height: 80, alignment: .center)
                        .imageScale(.large)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.order.mekanik?.name ?? "N/A")
                        .font(.system(size: 17))
                    Text("Mekanik")
                        .font(.system(size: 13))
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    var onProgressView: some View {
        Button {
            isShowFinishBookingSheet.toggle()
        } label: {
            Text("Pesanan Selesai")
                .frame(width: 310, height: 44)
                .foregroundColor(.white)
                .background(AppColor.primaryColor)
                .cornerRadius(8)
                .frame(width: 320, height: 45, alignment: .center)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.motorModel)
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                        Text(viewModel.customerName)
                            .font(.system(size: 15))
                        HStack {
                            Image(systemName: "phone.circle.fill")
                                .font(.system(size: 18))
                            Button {
                                guard let number = URL(string: "tel://" + "\(viewModel.customerNumber)"), number.isValidURL else { return }
                                UIApplication.shared.open(number)
                            } label: {
                                Text(viewModel.customerNumber)
                                    .font(.system(size: 15))
                            }
                            Spacer()
                        }
                        .foregroundColor(AppColor.primaryColor)
                    }
                    Image("MotorGray")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding()
                    HStack {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Hari: ").font(.system(size: 13))
                                Spacer()
                            }
                            HStack {
                                Text("Jam: ").font(.system(size: 13))
                                Spacer()
                            }
                            HStack {
                                Text("Jenis Layanan").font(.system(size: 13))
                                Spacer()
                            }
                            HStack {
                                Text("Catatan: ").font(.system(size: 13))
                                Spacer()
                            }.font(.subheadline)
                        }
                        VStack(spacing: 16) {
                            HStack {
                                Text(viewModel.orderDate)
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.orderHour)
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.typeOfService)
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.notes)
                                Spacer()
                            }
                        }.font(.subheadline.weight(.semibold))
                    }

                    switch viewModel.order.status {
                    case .waitingConfirmation: waitingConfirmationView
                    case .scheduled: scheduledView
                    case .onProgress: onProgressView
                    default: EmptyView()
                    }
                }.sheet(isPresented: $isShowFinishBookingSheet) {
                    FinishBookingView(order: viewModel.order)
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 50)
            .addPartialSheet()
            .navigationBarColor(Color(hex: "F9F9F9"))
            .navigationBarTitle("Detail Booking Masuk", displayMode: .inline)
            .navigationBarItems(
                leading: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.backward")
                        Text("Kembali")
                    }.foregroundColor(.white)
                }
            )
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
                self.uiTabarController = UITabBarController
            }
            .onDisappear {
                self.uiTabarController?.tabBar.isHidden = false
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.viewOnAppear()
        }
    }
}

struct DetailBooking_Previews: PreviewProvider {
    static var previews: some View {
        DetailBookingView(order: .preview)
    }
}
