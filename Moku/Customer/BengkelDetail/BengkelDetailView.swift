//
//  BengkelDetailView.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet
import SDWebImageSwiftUI

enum ActiveNavigationLink: String, Identifiable {
    case rating
    case bengkelDate

    var id: String { self.rawValue }
}

struct BengkelDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: BengkelDetailViewModel

    @State var isBackToRoot = false
    @Binding var tab: CustomerView.Tab

    init(bengkel: Bengkel, tab: Binding<CustomerView.Tab>) {
        let viewModel = BengkelDetailViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
        _tab = tab
    }

    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left.circle")
        }
    }

    var body: some View {
        VStack {
            // MARK: Navigation Links
            NavigationLink(destination: BengkelDateView(typeOfService: viewModel.typeOfService,
                                                        bengkel: viewModel.bengkel,
                                                        tab: $tab,
                                                        isBackToRoot: $isBackToRoot),
                           tag: ActiveNavigationLink.bengkelDate,
                           selection: $viewModel.activeNavigationLink) { EmptyView() }
            NavigationLink(destination: UlasanPage(bengkel: viewModel.bengkel),
                           tag: ActiveNavigationLink.rating,
                           selection: $viewModel.activeNavigationLink) { EmptyView() }
            contentView
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = true
                    viewModel.uiTabarController = UITabBarController
                }
                .onWillDisappear {
                    viewModel.uiTabarController?.tabBar.isHidden = false
                }
        }
    }

    private var contentView: some View {
        VStack(spacing: 16) {
            // MARK: - Workshop Photo
            if let photo = viewModel.workshopPhoto,
               let url = URL(string: photo) {
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
                    .height(280)
                    .clipShape(Rectangle())
            } else {
                VStack {
                    Image("MokuBanner")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Rectangle())
                }
            }

            // MARK: - Workshop Detail
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(viewModel.bengkel.name).semibold()
                    Spacer()
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.accentColor)
                        .onTapGesture(perform: favoriteToggle)
                }.font(.title3)
                Text(viewModel.address ?? "Unnamed Road")
                    .lineLimit(2)
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
                    .unredacted(when: viewModel.address != nil)
            }.padding(.horizontal)

            // MARK: - Actionable Items
            HStack {
                // MARK: Rating
                CollectionInfoDetailBengkel(
                    titleInfo: "Rating",
                    imageInfo: "star.fill",
                    mainInfo: viewModel.bengkel.averageRating,
                    bengkel: viewModel.bengkel,
                    cta: .seeAll
                ) {
                    viewModel.activeNavigationLink = .rating
                }

                Spacer()

                // MARK: Distance
                CollectionInfoDetailBengkel(
                    titleInfo: "Jarak dari Anda",
                    mainInfo: viewModel.distance,
                    bengkel: viewModel.bengkel,
                    cta: .seeMap
                ) {
                    MapHelper.direct(bengkel: viewModel.bengkel)
                }

                Spacer()

                // MARK: Operational Hours
                CollectionInfoDetailBengkel(
                    titleInfo: "Jam Buka",
                    mainInfo: viewModel.operationalHours,
                    bengkel: viewModel.bengkel,
                    cta: .seeDetail
                ) {
                    viewModel.isOperatinalHoursSheetShowing.toggle()
                }
            }.padding(.horizontal, .large)

            // MARK: Divider
            Rectangle()
                .height(4)
                .foregroundColor(.secondarySystemBackground)
                .padding(.top, .small)

            // MARK: Service Type
            VStack(alignment: .leading) {
                Text("Pilih Jasa").font(.headline)
                HStack(spacing: 12) {
                    SelectServices(serviceTitle: "Service Rutin",
                                   serviceIcon: "ServiceRutinIllustration",
                                   servicePrice: viewModel.priceRange,
                                   isSelected: viewModel.typeOfService == .servisRutin)
                        .onTapGesture {
                            viewModel.typeOfService = .servisRutin
                        }
                    SelectServices(serviceTitle: "Perbaikan",
                                   serviceIcon: "PerbaikanIllustration",
                                   servicePrice: "Disesuaikan di Bengkel",
                                   isSelected: viewModel.typeOfService == .perbaikan)
                        .onTapGesture {
                            viewModel.typeOfService = .perbaikan
                        }
                }
            }.padding(.horizontal)

            Spacer()

            // MARK: Order Button
            Button {
                viewModel.activeNavigationLink = .bengkelDate
            } label: {
                Text("Pesan")
                    .padding()
                    .maxWidth(.infinity)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }.padding(.horizontal, .large)
        }
        .addPartialSheet()
        .partialSheet(isPresented: $viewModel.isOperatinalHoursSheetShowing) {
            SheetView(mainInfo: viewModel.operationalHours)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTransparent(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    func favoriteToggle() {
        viewModel.toggleFavorite()
    }
}
