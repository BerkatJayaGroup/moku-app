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

    var onSelect: ((Location) -> Void)?

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
                    LocationSelectionView { location in
                        onSelect?(location)
                        presentationMode.wrappedValue.dismiss()
                    }
                }

            SearchBar("Cari alamat", text: $viewModel.searchQuery)

            searchResults()
            Spacer()
        }.padding()
    }
}

// MARK: - View Components
extension LocationSearchView {
    // MARK: - Search Results
    @ViewBuilder
    private func searchResults() -> some View {
        if viewModel.searchResults.isEmpty {
            if let location = viewModel.userLocation {
                Button {
                    onSelect?(location)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "scope")
                            .foregroundColor(.secondaryLabel)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Current Location")
                            Text(location.address)
                                .font(.subheadline)
                                .foregroundColor(.secondaryLabel)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.small)
                    .padding(.vertical)
                }.foregroundColor(.primary)
                Divider()
            }
        } else {
            List(viewModel.searchResults) { place in
                Button {
                    viewModel.getLocation(from: place) { location in
                        onSelect?(location)
                        presentationMode.wrappedValue.dismiss()
                    }
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

// MARK: - View Extension
extension LocationSearchView {
    struct LocationSearchSheetStyle: ViewModifier {
        func body(content: Content) -> some View {
            VStack {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 56, height: 6)
                        .foregroundColor(.quaternaryLabel)
                    Spacer()
                }.padding([.top, .horizontal])

                content
            }
        }
    }

    func sheetStyle() -> some View {
        modifier(LocationSearchSheetStyle())
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
