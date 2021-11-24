//
//  BengkelTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import Introspect
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BengkelTabItem: View {
    @ObservedObject private var viewModel = ViewModel.shared
    @ObservedObject private var locationService = LocationService.shared
    @ObservedObject var session = SessionService.shared

    @State private var showingSheet = false
    @State private var showModal = false
    @State var isActive: Bool = false
    @State var isHideTabBar: Bool = false
    var lastOrder = true

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    ShapeBg()
                        .frame(height: 140)
                        .foregroundColor(Color("PrimaryColor"))
                    VStack(alignment: .leading) {
                        Spacer(minLength: 40)
                        NavigationLink(destination: googleMap()) {
                            Image(systemName: "mappin")
                                .padding(.vertical, 7)
                                .padding(.leading, 10)
                                .font(.system(size: 25))
                            Text(viewModel.currentLocation)
                                .font(.headline)
                                .padding(.vertical, 7)
                                .padding(.trailing, 15)
                        }
                        .sheet(isPresented: $showModal) {
                            ModalSearchLocation(showModal: $showModal)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        motorSelection()
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.systemGray3))
                            TextField("Cari Bengkel", text: $viewModel.searchQuery)
                        }
                        .padding(8)
                        .padding(.leading, 5)
                        .background(Color.white, alignment: .center)
                        .cornerRadius(7)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                        .padding(.horizontal, 20)

                        if case .customer(let user) = session.user {
                            if !user.favoriteBengkel.isEmpty{
                                bengkelFavoriteView(user: user)
                            }
                        }
                      
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .frame(height: 5)
                            .edgesIgnoringSafeArea(.horizontal)
                        ratingView()
                        listOfNearbyBengkel()
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = self.isHideTabBar
            }
        }
        .onAppear{
            session.setup()
        }
    }
    @ViewBuilder
    private func ratingView() -> some View {
        if !viewModel.ordersToRate.isEmpty {
                VStack(alignment: .leading) {
                    Text("Kasih rating dulu yuk!")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.ordersToRate, id: \.id) { orderRate in
                                Rating(order: orderRate, isFrom: true)
                                    .frame(width: 325)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                                    .padding()
                            }
                        }
                    }
                }.padding()
        }
    }
    private func googleMap() -> some View {
        GoogleMapView(coordinate: $locationService.userCoordinate) { _ in } onAnimationEnded: { coordinate in
            locationService.userCoordinate = coordinate
        }.ignoresSafeArea(edges: [.top, .horizontal])
    }

    @ViewBuilder
    private func listOfNearbyBengkel() -> some View {
        if BengkelRepository.shared.bengkel.isEmpty {
            VStack {
                Image("EmptyBengkelPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .padding(72)
            }
        } else {
            LazyVStack {
                ForEach(BengkelRepository.shared.bengkel, id: \.id) { bengkel in
                    NavigationLink(
                        destination: BengkelDetail(
                            bengkel: bengkel,
                            isRootActive: self.$isActive,
                            isHideTabBar: self.$isHideTabBar
                        )) {
                        BengkelList(bengkel: bengkel)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                    }
                }
            }
            .padding(10)
            .padding(.horizontal, 10)
        }
    }

    @ViewBuilder
    private func motorSelection() -> some View {
        if viewModel.isCustomer {
            HStack {
                Text("Ingin Memperbaiki")
                    .foregroundColor(Color.white)
                    .padding(.leading, 20)
                    .font(.system(size: 17))
                Button {
                    showingSheet = true
                } label: {
                    Text(viewModel.sessionService.selectedMotor?.model ?? "N/A")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .bold))
                        .offset(x: -5)
                }
                .foregroundColor(Color.white)
                .sheet(isPresented: $showingSheet) {
                    MotorModal(
                        availableMotors: viewModel.customerMotors,
                        selectedMotor: $viewModel.sessionService.selectedMotor,
                        showingSheet: $showingSheet
                    )
                }
            }
        } else {
            Button {

            } label: {
                Text("Daftar atau Masuk")
                    .foregroundColor(Color.white)
                    .padding(.leading, 20)
                    .font(.system(size: 17))
            }
        }
    }

    private func bengkelFavoriteView(user: Customer) -> some View {
        VStack(alignment: .leading) {
            Text("Bengkel Favorit")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(user.favoriteBengkel, id: \.name) { bengkel in
                        NavigationLink(
                            destination: BengkelDetail(
                                bengkel: bengkel,
                                isRootActive: self.$isActive,
                                isHideTabBar: self.$isHideTabBar
                            )) {
                            FavoriteList(bengkel: bengkel)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                            }
                    }
                }
                .padding(5)
            }
        }
        .padding(10)
        .padding(.horizontal, 10)
    }

}

struct BengkelTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BengkelTabItem()
    }
}
