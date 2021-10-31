//
//  LocationSearchView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 31/10/21.
//

import SwiftUI
import SwiftUIX

struct LocationSearchView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Pilih Lokasimu").font(.headline)
                Spacer()
                Button {
                    viewModel.isMapOpen.toggle()
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
            }.padding(.small)
                .fullScreenCover(isPresented: $viewModel.isMapOpen) {
                    LocationSelectionView { coordinate in
                        print(coordinate)
                        viewModel.selectedCoordinate = coordinate
                    }
                }

            SearchBar("Cari alamat", text: $viewModel.searchQuery)

            searchResults()
            Spacer()
        }.padding()
    }
}

extension LocationSearchView {
    // MARK: - Search Results
    @ViewBuilder
    private func searchResults() -> some View {
        if viewModel.searchResults.isEmpty {
            if let userAddress = viewModel.userAddress {
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "scope")
                        .foregroundColor(.secondaryLabel)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Current Location")
                        Text(userAddress).font(.subheadline).foregroundColor(.secondaryLabel)
                    }
                }
                .padding(.small)
                .padding(.vertical)
                Divider()
            }
        } else {
            List(viewModel.searchResults) { place in
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                        if let address = place.address {
                            Text(address).font(.subheadline).foregroundColor(.secondaryLabel)
                        }
                    }.padding(.small)
                }
            }.listStyle(PlainListStyle())
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
//        Text("Hello")
//            .sheet(isPresented: .constant(true)) {
//                    HStack {
//                        Spacer()
//                        RoundedRectangle(cornerRadius: 8)
//                            .frame(width: 56, height: 6)
//                            .foregroundColor(.quaternaryLabel)
//                        Spacer()
//                    }.padding([.top, .horizontal])
                    LocationSearchView()
//            }
    }
}
