//
//  BengkelTabItem+Header.swift
//  Moku
//
//  Created by Christianto Budisaputra on 10/12/21.
//

import SwiftUI

extension BengkelTabItem {
    var headerLocation: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Strings.nearestBengkel).font(.subheadline)
            Button {
                viewModel.showChooseLocationTray()
            } label: {
                HStack {
                    Text(viewModel.currentLocation ?? "Location Not Found")
                    Image(systemName: "chevron.down")
                }.font(.body.weight(.semibold))
            }
        }.unredacted(when: viewModel.currentLocation != nil)
    }

    var headerToolBar: some View {
        HStack {
            Button {
                viewModel.showChooseMotorTray()
            } label: {
                HStack {
                    if let selectedMotorcycleModel = viewModel.selectedMotorcycleModel {
                        Text(selectedMotorcycleModel)
                    } else {
                        Text(Strings.userHasNoMotorcycle)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .font(.subheadline.weight(.semibold))
                .padding(.small)
                .background(Color.white)
                .foregroundColor(.accentColor)
                .cornerRadius(8)
            }

            Button {

            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline.weight(.semibold))
                    .padding(.small)
                    .foregroundColor(.accentColor)
                    .background(Color.white)
                    .cornerRadius(8)
            }

            Button {

            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.subheadline.weight(.semibold))
                    .padding(9)
                    .foregroundColor(.accentColor)
                    .background(Color.white)
                    .cornerRadius(8)
            }
        }
    }

    var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerLocation
            headerToolBar
        }.foregroundColor(.white)
    }

    var headerViewBackground: some View {
        ShapeBg()
            .height(180)
            .foregroundColor(.accentColor)
            .edgesIgnoringSafeArea([.leading, .top, .trailing])
    }

    func pageIndicator() -> some View {
        HStack {
            ForEach(0..<viewModel.banners.count) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(viewModel.activeBannerIndex == index ? .accentColor : .secondarySystemBackground)
            }
        }
    }
}
