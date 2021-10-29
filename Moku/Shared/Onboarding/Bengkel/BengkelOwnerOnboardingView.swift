//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI

struct BengkelOwnerOnboardingView: View {
    @State var ownerName: String = ""
    @State var isNavigateActive = false

    @ObservedObject var locationService = LocationService.shared
    @State var isSelectingLocation = false

    @StateObject var viewModel = ViewModel()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            NavigationLink(destination: googleMap(), isActive: $viewModel.isMapOpen) { EmptyView() }
            Form {
                Section(header: Text("NAMA PEMILIK")) {
                    TextField("Tulis namamu disini", text: $ownerName)
                }
                Section(header: Text("NAMA BENGKEL")) {
                    TextField("Tulis nama bengkelmu disini", text: $viewModel.name)
                }
                Section(header: Text("ALAMAT")) {
                    Button {
                        isSelectingLocation = true
                    } label: {
                        if let address = viewModel.address {
                            Text(address).foregroundColor(.primary)
                        } else {
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text("Cari alamat bengkelmu disini")
                            }.foregroundColor(.tertiaryLabel)
                        }
                    }
                }
                Section(header: Text("NOMOR TELEPON BENGKEL")) {
                    TextField("08xx-xxxx-xxxx", text: $viewModel.phoneNumber).keyboardType(.numberPad)
                }
                Section(header: Text("FOTO BENGKEL")) {
                    // UI IMAGE PICKER
                }
            }
            NavigationLink(destination: PengaturanBengkel(), isActive: $isNavigateActive) {
                Button("Lanjutkan") { self.isNavigateActive = true }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.horizontal)
            }

        }
        .sheet(isPresented: $isSelectingLocation) {
            selectLocation()
        }
        .navigationBarTitle("Profil Bengkel", displayMode: .inline)
    }

    private func selectLocation() -> some View {
        VStack {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 56, height: 6)
                    .foregroundColor(.quaternaryLabel)
                Spacer()
            }.padding(.bottom)

            HStack {
                Text("Pilih Lokasimu").font(.title3.bold())
                Spacer()
                Button {
                    isSelectingLocation = false
                    viewModel.openMap()
                } label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill").imageScale(.small)
                        Text("Pilih Lokasi").font(.subheadline.bold())
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background(AppColor.primaryColor)
                    .cornerRadius(8)
                }
            }

            SearchBarLocation(text: $viewModel.query)

            List(viewModel.results) { place in
                Button(place.address) {
                    viewModel.setBengkelLocation(as: place)
                    isSelectingLocation = false
                }
            }.listStyle(PlainListStyle())

            Spacer()
        }.padding()
    }

    private func dismissMap() {
        viewModel.closeMap()
    }

    private func locationDetail() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Pilih Lokasi").font(.title3.bold())
                Spacer()
            }
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.largeTitle).foregroundColor(AppColor.primaryColor)
                Text(viewModel.address ?? "Invalid Location")
            }
            Button {

            } label: {
                HStack {
                    Spacer()
                    Text("Konfirmasi Lokasi")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.regular)
                .background(AppColor.primaryColor)
                .cornerRadius(8)
            }.padding(.horizontal, .regular)
        }
        .padding(20)
        .padding(.bottom, 26)
        .background(Color.white.cornerRadius(16, corners: [.topLeft, .topRight]).shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: -2))
    }

    private func actionButton() -> some View {
        HStack {
            Button {
                dismissMap()
            } label: {
                Image(systemName: "xmark").font(.title2.bold())
                    .foregroundColor(AppColor.primaryColor)
                    .padding(.small)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            }
            Spacer()
            Button {
                viewModel.centerLocation()
            } label: {
                Image(systemName: "location.fill").font(.title2)
                    .foregroundColor(AppColor.primaryColor)
                    .padding(.small)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            }
        }
        .padding(.small)
        .padding(.horizontal, 10)

    }

    private func googleMap() -> some View {
        ZStack {
            VStack {
                GoogleMapView(coordinate: $viewModel.selectedCoordinate, onInit: viewModel.assignMapView) { coordinate in
                    viewModel.selectedCoordinate = coordinate
                    MapHelper.geocode(absolute: true, coordinate: coordinate) { address in
                        viewModel.location = Location(
                            address: address,
                            longitude: coordinate.longitude,
                            latitude: coordinate.latitude
                        )
                    }
                }.ignoresSafeArea()
                Spacer(minLength: 180)
            }

            VStack {
                Spacer()
                actionButton()
                locationDetail()
            }.edgesIgnoringSafeArea(.bottom)
        }
        .hideNavigationBarIfAvailable()
        .onAppear {
            MapHelper.geocode(absolute: true, coordinate: viewModel.selectedCoordinate) { address in
                viewModel.location = Location(
                    address: address,
                    longitude: locationService.userCoordinate.longitude,
                    latitude: locationService.userCoordinate.latitude
                )
            }
        }
    }
}

struct BengkelOwnerOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BengkelOwnerOnboardingView()
    }
}
