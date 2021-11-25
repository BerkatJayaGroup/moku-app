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
    
    init(order: Order) {
        let viewModel = ViewModel(order: order, showModal: false)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.backgroundColor = UIColor.white
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        VStack {
            ScrollView{
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
                Image(systemName: "bicycle")
                    .frame(width: 260, height: 160, alignment: .center)
                VStack(spacing: 16) {
                    HStack {
                        Text("Hari: ")
                        Spacer()
                        Text(viewModel.orderDate)
                    }
                    HStack {
                        Text("Jam: ")
                        Spacer()
                        Text(viewModel.orderHour)
                    }
                    HStack {
                        Text("Jenis Layanan")
                        Spacer()
                        Text(viewModel.typeOfService)
                    }
                    HStack {
                        Text("Catatan: ")
                        Spacer()
                        Text(viewModel.notes)
                    }
                }
                Spacer()
            }
            switch viewModel.order.status {
            case .waitingConfirmation:
                Button{
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
                if (viewModel.order.schedule.get(.day) == Date().get(.day)){
                    Button(action: {
                        print("Kerjakan Pesanan")
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                        //                    viewModel.updateStatusOrder()
                    }, label: {
                        Text("Kerjakan")
                            .frame(width: 310, height: 44)
                            .foregroundColor(.white)
                            .background(AppColor.primaryColor)
                            .cornerRadius(8)
                            .frame(width: 320, height: 45, alignment: .center)
                    })
                }
                else{
                    Divider()
                        .padding(.horizontal)
                    HStack{
                        Text("Mekanik yang ditugaskan")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "person.crop.circle")
                            .frame(width: 80, height: 80, alignment: .center)
                            .imageScale(.large)
                            .clipShape(Circle())
                        VStack(spacing: 8){
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
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                    //                    viewModel.updateStatusOrder()
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
        .padding()
        .addPartialSheet()
        .navigationTitle("Detail Booking Masuk")
        .navigationBarColor(.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailBooking_Previews: PreviewProvider {
    static var previews: some View {
        DetailBooking(order: .preview)
    }
}
