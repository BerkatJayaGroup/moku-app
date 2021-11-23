//
//  BengkelDetail.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet
import SwiftUIX
import SDWebImageSwiftUI

struct BengkelDetail: View {
    @ObservedObject var session = SessionService.shared
    @ObservedObject var customerRepo = CustomerRepository.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var heartTap: [String] = ["heart", "heart.fill"]
    @State private var indexHeart = 0
    @State var service1: Bool = true
    @State var service2: Bool = false
    @State var isFavorite: Bool = false

    @StateObject private var viewModel: ViewModel
    @Binding var isRootActive: Bool
    @Binding var isHideTabBar: Bool
    
    
    init(bengkel: Bengkel, isRootActive: Binding<Bool>, isHideTabBar: Binding<Bool>) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
        _isRootActive = isRootActive
        _isHideTabBar = isHideTabBar
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
                    if viewModel.bengkel.photos.count > 0 {
                        if let photo = viewModel.bengkel.photos[0] {
                            WebImage(url: URL(string: photo))
                                .resizable()
                                .frame(width: proxy.size.width, height: proxy.size.height * 0.33)
                                .scaledToFit()
                        }
                    }
                    else {
                    Image(systemName: "number")
                            .resizable()
                            .frame(width: proxy.size.width, height: proxy.size.height * 0.33)
                            .scaledToFit()
                    }

                    HStack {
                        Text(viewModel.bengkel.name)
                        Spacer()
                        if isFavorite{
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    favoriteToggle()
                                }
                        }
                        else{
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    favoriteToggle()
                                }
                        }
                    }
                    .font(Font.system(size: 22))
                    Text(viewModel.address)
                        .fontWeight(.light)
                        .frame(width: proxy.size.width)
                    HStack {
                        CollectionInfoDetailBengkel(
                            titleInfo: "Rating",
                            imageInfo: "star.fill",
                            mainInfo: viewModel.bengkel.averageRating,
                            cta: .seeDetail
                        ).style(proxy: proxy)

                        CollectionInfoDetailBengkel(
                            titleInfo: "Jarak dari Anda",
                            imageInfo: "",
                            mainInfo: viewModel.distance,
                            cta: .seeDetail
                        ) {
                            MapHelper.direct(bengkel: viewModel.bengkel)
                        }.style(proxy: proxy)

                        CollectionInfoDetailBengkel(
                            titleInfo: "Jam Buka",
                            imageInfo: "",
                            mainInfo: viewModel.operationalHours,
                            cta: .seeDetail
                        ).style(proxy: proxy)

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
                    NavigationLink(destination: BengkelDate(typeOfService: viewModel.typeOfService, bengkel: viewModel.bengkel, isRootActive: self.$isRootActive, isHideTabBar: self.$isHideTabBar)) {
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
            .onAppear{
                if case .customer(let user) = session.user {
                    if user.favoriteBengkel.contains(where: {$0.name == viewModel.bengkel.name}){
                        print("berubah")
                        isFavorite = true
                    }
                }
            }
            .onDisappear {
                session.setup()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .padding(.horizontal, 16)
    }
    
    func favoriteToggle(){
        if isFavorite == true {
            isFavorite = false
            if case .customer(var user) = session.user {
                print("remove")
                user.favoriteBengkel.removeAll(where: {$0.name == viewModel.bengkel.name})
                customerRepo.update(customer: user)
            }
        } else {
            isFavorite = true
            if case .customer(var user) = session.user {
                print("add")
                user.favoriteBengkel.append(viewModel.bengkel)
                customerRepo.update(customer: user)
            }
        }
    }
}
