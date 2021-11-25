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
    @State var isShowUlasan: Bool = false
    @State var isBackToRoot = false
    @State var isFavorite: Bool = false

    @StateObject private var viewModel: ViewModel

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @Binding var tab: Tabs

    init(bengkel: Bengkel, tab: Binding<Tabs>) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
        self._tab = tab
    }

    var btnBack: some View {
        Button {
            mode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left.circle")
                .foregroundColor(Color("PrimaryColor"))
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
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
                        .scaledToFill()
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
                        ) {
                            isShowUlasan.toggle()
                        }
                        .style(proxy: proxy)
                        .sheet(isPresented: $isShowUlasan) {
                            UlasanPage(bengkel: viewModel.bengkel)
                        }
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
                    NavigationLink(destination: BengkelDate(typeOfService: viewModel.typeOfService, bengkel: viewModel.bengkel, tab: $tab, isBackToRoot: $isBackToRoot)) {
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
        .addPartialSheet()
        .onAppear {
            if isBackToRoot {
                mode.wrappedValue.dismiss()
                self.isBackToRoot = false
            } else {
                
                
            }
        }
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

class SomeData: ObservableObject {
    @Published var isOn: Bool = false
}
