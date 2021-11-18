//
//  BookingDetail.swift
//  Moku
//
//  Created by Dicky Buwono on 09/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookingDetail: View {
    let order: Order
    @State private var showingSheet = false
    @State var bengkel: Bengkel?

    var body: some View {
        content.onAppear {
            BengkelRepository.shared.fetch(id: order.bengkelId) { bengkel in
                self.bengkel = bengkel
            }
        }
    }

    @ViewBuilder private var content: some View {
        if let bengkel = bengkel {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text(bengkel.name)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(5)
                        Text(bengkel.address)
                            .font(.caption)
                            .foregroundColor(AppColor.darkGray)
                    }
                    VStack(alignment: .leading) {
                        Divider()
                        HStack {
                            if let photo = order.mekanik?.photo {
                                WebImage(url: URL(string: photo))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 70))
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(order.mekanik?.name ?? "n/a")
                                    .font(.system(size: 17, weight: .regular))
                                Text("Mekanik")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                            }
                        }
                        Divider()
                    }
                    .padding(.vertical)
                    VStack(alignment: .leading) {
                        Text("Keterangan Booking")
                            .font(.system(size: 17, weight: .semibold))
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Motor")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Jenis Perbaikan")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Hari")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Jam")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                            }.padding(.vertical)
                            Spacer(minLength: 1)
                            VStack(alignment: .leading, spacing: 20) {
                                Text(order.motor.brand.rawValue + ", " + order.motor.model)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(order.typeOfService.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(Date.convertDateFormat(date: order.schedule, format: "eeee, d MMMM YYYY"))
                                    .font(.system(size: 13, weight: .semibold))
                                Text(Date.convertDateFormat(date: order.schedule, format: "HH:mm"))
                                    .font(.system(size: 13, weight: .semibold))
                            }.padding(.vertical)
                        }
                    }
                    Spacer()
                    if order.status == Order.Status.done {
                        VStack(alignment: .leading) {
                            Divider()
                            Text("Foto Nota")
                                .font(.system(size: 17, weight: .semibold))
                            if let imageNota = order.nota {
                                Button {
                                    showingSheet.toggle()
                                }label: {
                                    WebImage(url: URL(string: imageNota))
                                        .frame(width: 100, height: 100)
                                        .scaledToFill()
                                        .cornerRadius(9)
                                        .padding(.vertical, 10)
                                }.fullScreenCover(isPresented: $showingSheet) {
                                    ImageFullComp(imageUrl: imageNota)
                                }
                            } else {
                                Image(systemName: "doc.text.image")
                                    .font(.system(size: 100))
                                    .cornerRadius(9)
                                    .padding(.vertical, 10)
                            }
                            Divider()
                            Text("Kasih Rating Dulu Yuk!")
                                .font(.system(size: 17, weight: .semibold))
                            Rating(order: order)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                                .padding(.horizontal, 5)
                        }
                        .padding(.bottom)
                    }
                }
                if order.status == Order.Status.waitingSchedule {
                    Button {
                    }label: {
                        Text("Batalkan Booking")
                    }
                    .frame(width: 300, height: 50)
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 30)
            .navigationTitle("Booking Detail")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ActivityIndicator(.constant(true))
        }
    }
}

struct BookingDetail_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetail(order: .preview)
    }
}
