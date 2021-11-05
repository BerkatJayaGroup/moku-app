//
//  BengkelDetail.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI

struct BengkelDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var heartTap: [String] = ["heart", "heart.fill"]
    @State private var indexHeart = 0
    @State var service1: Bool = true
    @State var service2: Bool = false

    @StateObject private var viewModel: ViewModel

    init(bengkel: Bengkel) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var btnBack: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left.circle")
                .foregroundColor(Color("PrimaryColor"))
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "number")
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height * 0.33)
                        .scaledToFit()

                    HStack {
                        Text(viewModel.bengkel.name)
                        Spacer()
                        Image(systemName: heartTap[indexHeart])
                            .foregroundColor(.red)
                            .onTapGesture {
                                if indexHeart == 1 {
                                    indexHeart = 0
                                } else {
                                    indexHeart = 1
                                }
                            }
                    }
                    .font(Font.system(size: 22))
                    Text(viewModel.address)
                        .fontWeight(.light)
                        .frame(width: proxy.size.width)
                    HStack {
                        CollectionInfoDetailBengkel(titleInfo: "Rating", imageInfo: "star.fill", mainInfo: viewModel.bengkel.averageRating, cta: "Lihat Semua")
                            .padding(.all, 4)
                            .frame(width: proxy.size.width * 0.3, alignment: .center)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)
                        CollectionInfoDetailBengkel(titleInfo: "Jarak dari Anda", imageInfo: "", mainInfo: viewModel.distance, cta: "Lihat Peta")
                            .padding(.all, 4)
                            .frame(width: proxy.size.width * 0.3, alignment: .center)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)
                        CollectionInfoDetailBengkel(titleInfo: "Jam Buka", imageInfo: "", mainInfo: viewModel.operationalHours, cta: "Lihat Detail")
                            .padding(.all, 4)
                            .frame(width: proxy.size.width * 0.3, alignment: .center)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(8)
                    }
                    .frame(width: proxy.size.width)
                    Text("Pilih Jasa")
                        .fontWeight(.semibold)
                        .frame(width: proxy.size.width, alignment: .leading)
                    HStack {
                        SelectServices(serviceTitle: "Service Rutin", serviceIcon: "gearshape.2", servicePrice: "Rp 40.000 - Rp 150.000", isTap: viewModel.typeOfService == .servisRutin)
                            .onTapGesture {
                                viewModel.typeOfService = .servisRutin
                            }
                        SelectServices(serviceTitle: "Perbaikan", serviceIcon: "wrench.and.screwdriver", servicePrice: "Tanya bengkel", isTap: viewModel.typeOfService == .perbaikan)
                            .onTapGesture {
                                viewModel.typeOfService = .perbaikan
                            }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.3)
                    Spacer()
                    NavigationLink(destination: BengkelDate(typeOfService: viewModel.typeOfService, bengkel: viewModel.bengkel)){
                            Text("Pesan")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(width: proxy.size.width * 0.85)
                                .background(Color("PrimaryColor"))
                                .cornerRadius(8)
                        
                        //.disabled(viewModel.typeOfService == nil)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .padding(.horizontal, 16)
    }
}
