//
//  BengkelDetail.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet

struct BengkelDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var heartTap: [String] = ["heart", "heart.fill"]
    @State private var indexHeart = 0
    @State var service1: Bool = true
    @State var service2: Bool = false

    @StateObject private var viewModel: ViewModel

    @Binding var tab: Tabs

    init(bengkel: Bengkel, tab: Binding<Tabs>) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
        self._tab = tab
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
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "number")
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height * 0.33)
                        .scaledToFill()

                    HStack {
                        Text(viewModel.bengkel.name)
                        Spacer()
                        Image(systemName: heartTap[indexHeart])
                            .foregroundColor(AppColor.primaryColor)
                            .onTapGesture {
                                if indexHeart == 1 {
                                    indexHeart = 0
                                } else {
                                    indexHeart = 1
                                }
                            }
                    }
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.bottom, 5)
                    Text(viewModel.address)
                        .font(.system(size: 13, weight: .regular))
                        .frame(width: proxy.size.width)
                        .foregroundColor(AppColor.darkGray)
                        .padding(.bottom, 10)
                    HStack {
                        CollectionInfoDetailBengkel(
                            titleInfo: "Rating",
                            imageInfo: "star.fill",
                            mainInfo: viewModel.bengkel.averageRating,
                            cta: .seeAll
                        ).style(proxy: proxy)

                        CollectionInfoDetailBengkel(
                            titleInfo: "Jarak dari Anda",
                            imageInfo: "",
                            mainInfo: viewModel.distance,
                            cta: .seeMap
                        ) {
                            MapHelper.direct(bengkel: viewModel.bengkel)
                        }.style(proxy: proxy)

                        CollectionInfoDetailBengkel(
                            titleInfo: "Jam Buka",
                            imageInfo: "",
                            mainInfo: viewModel.operationalHours,
                            cta: .seeDetail
                        ) {
                            viewModel.isOperatinalHoursSheetShowing.toggle()
                            print(viewModel.isOperatinalHoursSheetShowing)
                        }
                        .style(proxy: proxy)
                        .partialSheet(isPresented: $viewModel.isOperatinalHoursSheetShowing) {
                            SheetView(mainInfo: viewModel.operationalHours)
                        }
                    }
                    .frame(width: proxy.size.width)
                    Text("Pilih Jasa")
                        .fontWeight(.semibold)
                        .frame(width: proxy.size.width, alignment: .leading)
                        .padding(.top)
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
                    NavigationLink(destination: BengkelDate(typeOfService: viewModel.typeOfService, bengkel: viewModel.bengkel, tab: $tab)) {
                            Text("Pesan")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(width: proxy.size.width * 0.85)
                                .background(Color("PrimaryColor"))
                                .cornerRadius(8)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .padding(.horizontal, 16)
        .addPartialSheet()
    }
}
