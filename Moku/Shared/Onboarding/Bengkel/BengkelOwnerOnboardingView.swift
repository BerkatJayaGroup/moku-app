//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI

struct BengkelOwnerOnboardingView: View {
    @State var ownerName: String = ""
    @State var bengkelName: String = ""
    @State var bengkelLocation: Location?
    @State var bengkelPhoneNumber: String = ""
    @State var isNavigateActive = false

    @ObservedObject var locationService = LocationService.shared
    @State var isSelectingLocation = false
    @State var isMapOpen = false
    @State var gatauApaan = ""

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            NavigationLink(destination: googleMap(), isActive: $isMapOpen) { EmptyView() }
            Form {
                Section(header: Text("NAMA PEMILIK")) {
                    TextField("Tulis namamu disini", text: $ownerName)
                }
                Section(header: Text("NAMA BENGKEL")) {
                    TextField("Tulis nama bengkelmu disini", text: $bengkelName)
                }
                Section(header: Text("ALAMAT")) {
                    Button {
                        isSelectingLocation = true
                    } label: {
                        if let address = bengkelLocation?.address {
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
                    TextField("08xx-xxxx-xxxx", text: $bengkelPhoneNumber).keyboardType(.numberPad)
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
                    isSelectingLocation.toggle()
                    isMapOpen.toggle()
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
            SearchBarLocation(text: $gatauApaan)
            Spacer()
        }.padding()
    }

    private func centerLocation() {

    }

    private func dismissMap() {
        self.isMapOpen = false
    }

    private func locationDetail() -> some View {
        VStack(spacing: 24) {
            HStack {
                Text("Pilih Lokasi").font(.title3.bold())
                Spacer()
            }
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.largeTitle).foregroundColor(AppColor.primaryColor)
                Text(bengkelLocation?.address ?? "Invalid Location")
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
        .padding(.large)
        .padding(.bottom, 24)
        .background(Color.white)
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
            }
            Spacer()
            Button {
                centerLocation()
            } label: {
                Image(systemName: "location.fill").font(.title2)
                    .foregroundColor(AppColor.primaryColor)
                    .padding(.small)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
        .padding(.small)
        .padding(.horizontal, 10)
    }

    private func googleMap() -> some View {
        ZStack {
            GoogleMapView(coordinate: $locationService.userCoordinate) { coordinate in
                locationService.userCoordinate = coordinate
                MapHelper.geocode(absolute: true, coordinate: coordinate) { address in
                    bengkelLocation = Location(
                        address: address,
                        longitude: coordinate.longitude,
                        latitude: coordinate.latitude
                    )
                }
            }.ignoresSafeArea()

            VStack {
                Spacer()
                actionButton()
                locationDetail()
            }.edgesIgnoringSafeArea(.bottom)
        }
//        .hideNavigationBar()
        .onAppear {
            MapHelper.geocode(absolute: true, coordinate: locationService.userCoordinate) { address in
                bengkelLocation = Location(
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
