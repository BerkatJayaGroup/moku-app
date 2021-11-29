//
//  AllReviewView.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import SwiftUI

struct AllReviewView: View {
    @StateObject var viewModel: ViewModel

    init(bengkel: Bengkel) {
        let viewModel = ViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        setupViews().navigationBarTitle("Ulasan", displayMode: .inline)
    }

    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 8)
            ForEach(viewModel.sortedListOfReview, id: \.timestamp) { review in
                ReviewCard(review: review).shadow(color: .black.opacity(0.1), radius: 3, x: 1, y: 1).padding(.horizontal)
            }
            Spacer(minLength: 8)
        }
        .padding(.vertical, .small)
        .sheet(isPresented: $viewModel.isPresentingSortingSheet) {
            NavigationView {
                List(SortType.allCases) { sortType in
                    HStack {
                        Button(sortType.rawValue) {
                            viewModel.selectedSortType = sortType
                        }.foregroundColor(.label)

                        Spacer()

                        if let selectedSortType = viewModel.selectedSortType, selectedSortType == sortType {
                            Image(systemName: "checkmark").foregroundColor(AppColor.primaryColor)
                        } else if viewModel.selectedSortType == nil, viewModel.sortType == sortType {
                            Image(systemName: "checkmark").foregroundColor(AppColor.primaryColor)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarItems(
                    leading: toggleSheetButton(text: "Batal"),
                    center: Text("Urutkan").bold(),
                    trailing: Button {
                        guard let selectedSortType = viewModel.selectedSortType else {
                            viewModel.isPresentingSortingSheet.toggle()
                            return
                        }
                        viewModel.sortType = selectedSortType
                        viewModel.selectedSortType = nil
                        viewModel.isPresentingSortingSheet.toggle()
                    } label: {
                        Text("Simpan")
                    },
                    displayMode: .inline
                )
            }
        }
    }

    @ViewBuilder func setupViews() -> some View {
        if viewModel.sortedListOfReview.isEmpty {
            VStack(spacing: 32) {
                Image("EmptyReviewPlaceholder")
                    .resizable()
                    .scaledToFit()
                Text("Bengkel Anda belum pernah menerima ulasan dari pelanggan")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }.padding(36)
        } else {
            contentView.navigationBarItems(trailing: toggleSheetButton(text: "Urutkan"))
        }
    }

    private func toggleSheetButton(text: String) -> some View {
        Button {
            viewModel.selectedSortType = nil
            viewModel.isPresentingSortingSheet.toggle()
        } label: {
            Text(text)
        }
    }
}

struct AllReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AllReviewView(bengkel: .preview)
    }
}
