//
//  BengkelTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import UIKit
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
    @State var selection: Int?
    @State var showLoginView = false
    @Binding var tab: Tabs
    var onboardingData = OnboardingDataModel.data
    var lastOrder = true

    var body: some View {
        ZStack(alignment: .top) {
            ShapeBg()
                .frame(height: 211)
                .foregroundColor(Color("PrimaryColor"))
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Button {
                    showModal.toggle()
                } label: {
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
                    LocationSearchView(onSelect: viewModel.updateLocation).sheetStyle()
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

                ScrollView {
                    if case .customer(let user) = session.user {
                        if !user.favoriteBengkel.isEmpty {
                            bengkelFavoriteView(user: user)
                        }
                    }
                    ratingView()
                    listOfNearbyBengkel()
                        .padding(.top, 10)
                }
            }.padding(.top, 111)
        }
        .onTapGesture {
            endTextEditing()
        }
        .edgesIgnoringSafeArea(.top)
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

    @ViewBuilder
    private func listOfNearbyBengkel() -> some View {
        if viewModel.filteredNearbyBengkel.isEmpty {
            VStack {
                Image("EmptyBengkelPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .padding(72)
            }
        } else {
            VStack {
                ForEach(viewModel.filteredNearbyBengkel.filter({
                    viewModel.searchQuery.isEmpty ? true : $0.name.contains(viewModel.searchQuery)
                }), id: \.id) { bengkel in
                    NavigationLink(
                        destination: BengkelDetail(bengkel: bengkel, tab: $tab)) {
                            BengkelList(bengkel: bengkel)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                        }
                        .padding(.horizontal, 20)
                }
            }
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
                self.showLoginView = true
            }label: {
                Text("Daftar atau Masuk")
                    .foregroundColor(Color.white)
                    .padding(.leading, 20)
                    .font(.system(size: 17), weight: .bold)
            }.fullScreenCover(isPresented: $showLoginView) {
                LoginView()
            }
        }
    }

    private func bengkelFavoriteView(user: Customer) -> some View {
        VStack(alignment: .leading) {
            Text("Bengkel Favorit")
                .font(.headline)
                .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(user.favoriteBengkel, id: \.name) { bengkel in
                        NavigationLink(
                            destination: BengkelDetail(
                                bengkel: bengkel,
                                tab: $tab
                            )) {
                                FavoriteList(bengkel: bengkel)
                                    .padding(10)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                            }
                    }
                    .padding(5)
                }
            }.padding(.horizontal, 20)
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(height: 5)
                .edgesIgnoringSafeArea(.horizontal)
        }.padding(.vertical, 20)
    }
}

 struct BengkelTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BengkelTabItem(tab: .constant(.tab1))
    }
 }
