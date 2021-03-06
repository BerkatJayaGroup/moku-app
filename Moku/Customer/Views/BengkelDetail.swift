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
    @State var selection: Int?
    @State var isShowLogin: Bool = false
    var workshop: Bengkel
    @StateObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var tab: Tabs

    init(bengkel: Bengkel, tab: Binding<Tabs>) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
        self._tab = tab
        self.workshop = bengkel
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
        VStack(alignment: .center, spacing: 8) {
            if viewModel.bengkel.photos.count > 0 {
                if let photo = viewModel.bengkel.photos[0] {
                    WebImage(url: URL(string: photo))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3)
                        .scaledToFill()
                }
            } else {
                Image(systemName: "number")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3)
                    .scaledToFill()
            }

            HStack {
                Text(viewModel.bengkel.name)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Spacer()
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .onTapGesture {
                            favoriteToggle()
                        }
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        .onTapGesture {
                            favoriteToggle()
                        }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .font(.system(size: 20, weight: .semibold))
            .padding(.bottom, 5)
            Text(viewModel.bengkel.address)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: UIScreen.main.bounds.width * 0.9, idealWidth: UIScreen.main.bounds.width * 0.9, maxWidth: UIScreen.main.bounds.width * 0.9, minHeight: 18, idealHeight: 18, maxHeight: 36, alignment: .leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(hex: "686868"))
                .padding(.bottom, 20)
            HStack {
                CollectionInfoDetailBengkel(
                    titleInfo: "Rating",
                    imageInfo: "star.fill",
                    mainInfo: viewModel.bengkel.averageRating,
                    bengkel: viewModel.bengkel,
                    cta: .seeAll
                ) {
                    isShowUlasan.toggle()
                }
                .style()
                .sheet(isPresented: $isShowUlasan) {
                    UlasanPage(bengkel: viewModel.bengkel)
                }
                CollectionInfoDetailBengkel(
                    titleInfo: "Jarak dari Anda",
                    imageInfo: "",
                    mainInfo: viewModel.distance,
                    bengkel: viewModel.bengkel,
                    cta: .seeMap
                ) {
                    MapHelper.direct(bengkel: viewModel.bengkel)
                }.style()

                CollectionInfoDetailBengkel(
                    titleInfo: "Jam Buka",
                    imageInfo: "",
                    mainInfo: viewModel.operationalHours,
                    bengkel: viewModel.bengkel,
                    cta: .seeDetail
                ) {
                    viewModel.isOperatinalHoursSheetShowing.toggle()
                }
                .style()
                .partialSheet(isPresented: $viewModel.isOperatinalHoursSheetShowing) {
                    SheetView(mainInfo: viewModel.operationalHours)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            Divider()
            Text("Pilih Jasa")
                .fontWeight(.semibold)
                .padding(.top)
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
            HStack {
                let minPrice = "\(viewModel.bengkel.minPrice)".toCurrencyFormat()
                let maxPrice = "\(viewModel.bengkel.maxPrice)".toCurrencyFormat()
                SelectServices(serviceTitle: "Service Rutin", serviceIcon: "SelectService-ServiceRutin", servicePrice: "\(minPrice)-\(maxPrice)", isTap: viewModel.typeOfService == .servisRutin)
                    .onTapGesture {
                        viewModel.typeOfService = .servisRutin
                    }
                SelectServices(serviceTitle: "Perbaikan", serviceIcon: "SelectService-Perbaikan", servicePrice: "Disesuaikan di Bengkel", isTap: viewModel.typeOfService == .perbaikan)
                    .onTapGesture {
                        viewModel.typeOfService = .perbaikan
                    }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
            Spacer()
            if viewModel.isLogin {
                NavigationLink(destination: BengkelDate(typeOfService: viewModel.typeOfService, bengkel: viewModel.bengkel, tab: $tab, isBackToRoot: $isBackToRoot), tag: 1, selection: $selection) {
                    Text("Pesan")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(width: UIScreen.main.bounds.width * 0.85)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(8)
                }
            } else {
                Button {
                    isShowLogin = true
                    isBackToRoot = true
                }label: {
                    Text("Pesan")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(width: UIScreen.main.bounds.width * 0.85)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(8)
                }.fullScreenCover(isPresented: $isShowLogin) {
                    LoginView()
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .padding(.horizontal, 16)
        .addPartialSheet()
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            if case .customer(let user) = session.user {
                if user.favoriteBengkel.contains(where: {$0.name == workshop.name}) {
                    isFavorite = true
                }
            }
        }
    }

    func favoriteToggle() {
        if isFavorite == true {
            isFavorite = false
            if case .customer(var user) = session.user {
                user.favoriteBengkel.removeAll(where: {$0.name == viewModel.bengkel.name})
                customerRepo.update(customer: user)
            }
        } else {
            isFavorite = true
            if case .customer(var user) = session.user {
                user.favoriteBengkel.append(viewModel.bengkel)
                customerRepo.update(customer: user)
            }
        }
        session.setup()
    }
}

struct BengkelDetail_Previews: PreviewProvider {
   static var previews: some View {
       BengkelDetail(bengkel: Bengkel.preview, tab: .constant(.tab1))
   }
}
