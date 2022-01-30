//
//  DetailBooking.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import PartialSheet

struct DetailBooking: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ViewModel
    @State var isShowRejectModal = false

    @State var isShowFinishBookingSheet = false

    init(order: Order) {
        let viewModel = ViewModel(order: order, showModal: false)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.motorModel)
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                        Text(viewModel.customerName)
                            .font(.system(size: 15))
                        HStack {
                            Image(systemName: "phone.circle.fill")
                                .font(.system(size: 18))
                            Button(action: {
                                guard let number = URL(string: "tel://" + "\(viewModel.customerNumber)") else { return }
                                UIApplication.shared.open(number)
                            }, label: {
                                Text(viewModel.customerNumber)
                                    .font(.system(size: 15))
                            })
                            Spacer()
                        }
                        .foregroundColor(AppColor.primaryColor)
                    }
                    Image("MotorGray")
                        .frame(width: 260, height: 160, alignment: .center)
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
                            }
                        }
                        VStack(spacing: 16) {
                            HStack {
                                Text(viewModel.orderDate).font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.orderHour).font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.typeOfService).font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.notes).font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }.sheet(isPresented: $isShowFinishBookingSheet) {
                    FinishBookingView(order: viewModel.order)
                }
                switch viewModel.order.status {
                case .waitingConfirmation:
                    Button {
                        print("Terima Booking")
                        viewModel.showModal = true
                    } label: {
                        Text("Terima Booking")
                            .frame(width: 310, height: 44)
                            .foregroundColor(.white)
                            .background(AppColor.primaryColor)
                            .cornerRadius(8)
                            .frame(width: 320, height: 45, alignment: .center)
                    }.partialSheet(isPresented: $viewModel.showModal) {
                        AssignMechanics(order: viewModel.order, isRootActive: $viewModel.showModal)
                    }.padding(.bottom, 16)
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
                case .scheduled :
                    if viewModel.order.schedule.get(.day) == Date().get(.day) {
                        Button(action: {
                            print("Kerjakan Pesanan")
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                            viewModel.updateStatusOrder(status: .onProgress)
                        }, label: {
                            Text("Kerjakan")
                                .frame(width: 310, height: 44)
                                .foregroundColor(.white)
                                .background(AppColor.primaryColor)
                                .cornerRadius(8)
                                .frame(width: 320, height: 45, alignment: .center)
                        })
                    } else {
                        Divider()
                            .padding(.horizontal)
                        HStack {
                            Text("Mekanik yang ditugaskan")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .frame(width: 80, height: 80, alignment: .center)
                                .imageScale(.large)
                                .clipShape(Circle())
                            VStack(spacing: 8) {
                                Text(viewModel.order.mechanicName ?? "N/A")
                                    .font(.system(size: 17))
                                Text("Mekanik")
                                    .font(.system(size: 13))
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                case .onProgress:
                    Button(action: {
                        print("Pesanan Selesai")
                        isShowFinishBookingSheet.toggle()
                    }, label: {
                        Text("Pesanan Selesai")
                            .frame(width: 310, height: 44)
                            .foregroundColor(.white)
                            .background(AppColor.primaryColor)
                            .cornerRadius(8)
                            .frame(width: 320, height: 45, alignment: .center)
                    })
                default:
                    EmptyView()
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 50)
            .addPartialSheet()
            .navigationTitle("Detail Booking Masuk")
            .navigationBarColor(Color(hex: "F9F9F9"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.backward")
                    Text("Kembali")
                }
                .foregroundColor(.white)
            })
        }.navigationBarHidden(true)
    }
}

struct DetailBooking_Previews: PreviewProvider {
    static var previews: some View {
        DetailBooking(order: .preview)
    }
}
