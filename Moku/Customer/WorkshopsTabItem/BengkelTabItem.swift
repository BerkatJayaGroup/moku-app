//
//  BengkelTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - View
struct BengkelTabItem: View {
    @StateObject var viewModel = ViewModel()
    @Binding var tabSelection: CustomerView.Tab

    init(tabSelection: Binding<CustomerView.Tab>) {
        _tabSelection = tabSelection
    }

    var body: some View {
        NavigationView {
            contentView
                .navigationBarHidden(true)
                .sheet(item: $viewModel.activeSheet) {
                    viewModel.activeSheet = nil
                } content: { activeSheet in
                    switch activeSheet {
                    case .location:
                        LocationSearchView(onSelect: viewModel.updateLocation).sheetStyle()
                    case .motor:
                        MotorModal(
                            availableMotors: viewModel.availableMotors,
                            selectedMotor: $viewModel.sessionService.selectedMotor,
                            showingSheet: $viewModel.isChoosingMotor
                        )
                    }
                }
        }
    }

    private var contentView: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                // MARK: - Promotional Banner(s)
                if !viewModel.banners.isEmpty {
                    ACarousel(viewModel.banners, index: $viewModel.activeBannerIndex, autoScroll: .active(16)) { banner in
                        WebImage(url: banner.imageUrl)
                            .resizable()
                            .scaledToFill()
                            .height(170)
                            .cornerRadius(12)
                    }
                    .height(170)
                    .padding(.top, 28)
                    pageIndicator().padding(.bottom)
                }

                // MARK: - Favorite Workshop(s)
                if !viewModel.favouriteWorkshops.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Strings.favouriteWorkshops).font(.headline).padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(viewModel.favouriteWorkshops, id: \.id) { bengkel in
                                    NavigationLink(destination: BengkelDetailView(bengkel: bengkel, tab: $tabSelection)) {
                                        FavoriteList(bengkel: bengkel)
                                    }.padding(.horizontal, .small)
                                }
                            }
                        }

                        Rectangle()
                            .height(4)
                            .foregroundColor(.secondarySystemBackground)
                            .padding(.top, .small)
                    }
                }

                // MARK: - Recent Order Rating
                if !viewModel.ordersToRate.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Strings.letsRate).font(.headline).padding(.horizontal)
                        ACarousel(viewModel.ordersToRate, id: \.id) { order in
                            Rating(order: order, isFrom: true)
                                .height(100)
                                .padding(.small)
                                .background(AppColor.primaryBackground)
                                .cornerRadius(10)
                                .applyShadow()
                        }.height(130)
                        Rectangle()
                            .height(4)
                            .foregroundColor(.secondarySystemBackground)
                            .padding(.top, .small)
                    }
                }

                listOfNearbyBengkel()
            }.padding(.top, 130)

            // MARK: - Header
            VStack {
                headerView
                    .padding([.horizontal, .top])
                    .background(headerViewBackground)

                Spacer()
            }
        }
    }

    // MARK: - Nearby Workshop(s)
    @ViewBuilder
    private func listOfNearbyBengkel() -> some View {
        if viewModel.nearbyWorkshops.isEmpty {
            VStack(spacing: 12) {
                Image("EmptyBengkelPlaceholder")
                    .resizable()
                    .scaledToFit()
                Text(Strings.noNearbyWorkshop)
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                    .multilineTextAlignment(.center)
            }.padding(72)
        } else {
            LazyVStack {
                ForEach(viewModel.nearbyWorkshops, id: \.id) { bengkel in
                    NavigationLink(destination: BengkelDetailView(bengkel: bengkel, tab: $tabSelection)) {
                        BengkelList(bengkel: bengkel)
                            .padding(.small)
                            .background(AppColor.primaryBackground)
                            .cornerRadius(8)
                            .applyShadow()
                    }
                }
            }.padding()
        }
    }

    private var bengkelFavoriteView: some View {
        VStack(alignment: .leading) {
            Text("Bengkel Favorit")
                .font(.headline)

        }
    }
}

// MARK: - Preview
struct BengkelTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BengkelTabItem(tabSelection: .constant(.bengkel))
            .environment(\.locale, .init(identifier: "id"))
    }
}
