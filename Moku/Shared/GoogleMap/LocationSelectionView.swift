//
//  LocationSelectionView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 31/10/21.
//

import SwiftUI
import CoreLocation

struct LocationSelectionView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = ViewModel()

    var onCommit: ((CLLocationCoordinate2D) -> Void)?

    var body: some View {
        ZStack {
            // Map Component
            GoogleMapView(coordinate: $viewModel.selectedCoordinate) { mapView in
                viewModel.assignMapView(mapView)
            } onAnimationEnded: { coordinate in
                viewModel.updateCoordinate(coordinate)
            }.ignoresSafeArea()

            // Location Component
            VStack {
                Spacer()

                HStack {
                    // Dismiss Button
                    Button {
                        // Dismiss View
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark").font(.title2.bold())
                            .foregroundColor(AppColor.primaryColor)
                            .padding(.small)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    }

                    Spacer()

                    // Center Button
                    Button {
                        viewModel.centerMapView()
                    } label: {
                        Image(systemName: "location.fill").font(.title2)
                            .foregroundColor(AppColor.primaryColor)
                            .padding(.small)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    }
                }.padding(.small).padding(.horizontal, 10)

                VStack(spacing: 20) {
                    HStack {
                        Text("Pilih Lokasi").font(.headline)
                        Spacer()
                    }

                    // Location Detail
                    HStack(spacing: 16) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.largeTitle).foregroundColor(AppColor.primaryColor)

                        VStack(alignment: .leading, spacing: 4) {
                            // Business Name
                            Text(viewModel.selectedLocationName).font(.subheadline.bold())
                            // Short Address
                            Text(viewModel.selectedLocationAddress).font(.caption)
                        }
                    }.padding(.horizontal, .regular)

                    // Confirm Button
                    Button {
                        onCommit?(viewModel.selectedCoordinate)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Konfirmasi Lokasi").font(.headline)
                            Spacer()
                        }
                        .padding(.regular)
                        .foregroundColor(viewModel.isLocationValid ? .white : .tertiaryLabel)
                        .background(viewModel.isLocationValid ? AppColor.primaryColor : Color.secondarySystemBackground)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, .regular)
                    .disabled(!viewModel.isLocationValid)
                }
                .padding()
                .background(
                    Color.white
                        .cornerRadius([.topLeft, .topRight], 16)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: -2)
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
        }.hideNavigationBarIfAvailable()
    }
}

struct LocationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectionView()
    }
}
