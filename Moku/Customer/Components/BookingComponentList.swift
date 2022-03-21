//
//  BookingComponentList.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

final class BookingComponentListViewModel: BookingComponentListViewModelProtocol {
    private let order: Order

    var motorcycleModelName: String {
        "\(order.motor.brand.rawValue.capitalized) \(order.motor.model)"
    }

    var typeOfService: String {
        order.typeOfService.rawValue
    }

    var schedule: String {
        Date.convertDateFormat(date: order.schedule, format: "eeee, d MMMM YYYY – HH:mm")
    }

    @Published var workshopName: String = "Nama Bengkel"

    @Published var workshopDisplayImageURL: URL?

    @Published var isLoading: Bool = true

    init(order: Order) {
        self.order = order
    }

    func viewOnAppear() {
        getBengkelOrders(bengkelId: order.bengkelId)
    }

    private func getBengkelOrders(bengkelId: String) {
        BengkelRepository.shared.fetch(id: bengkelId) { bengkel in
            self.isLoading = false
            self.workshopName = bengkel.name
            guard let photoUrl: String = bengkel.photos.first else { return }
            self.workshopDisplayImageURL = URL(string: photoUrl)
        }
    }
}

struct BookingComponentList<ViewModel>: View where ViewModel: BookingComponentListViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let photoUrl: URL = viewModel.workshopDisplayImageURL, photoUrl.isValidURL {
                WebImage(url: photoUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 144)
                    .cornerRadius(4)
                    .clipped()
            }

            Text(viewModel.workshopName).font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "bicycle")
                        .foregroundColor(.accentColor)
                        .width(32)
                    Text(viewModel.motorcycleModelName)
                    Spacer()
                }
                HStack {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.accentColor)
                        .width(32)
                    Text(viewModel.typeOfService)
                }
                HStack(alignment: .top) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.accentColor)
                        .width(32)
                    Text(viewModel.schedule)
                }
            }
            .font(.subheadline)
            .multilineTextAlignment(.leading)
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .padding()
        .foregroundColor(.label)
        .background(Color.systemBackground)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.075), radius: 3, x: 3, y: 3)
        .onAppear {
            viewModel.viewOnAppear()
        }
    }
}

struct BookingComponentList_Previews: PreviewProvider {
    static var previews: some View {
        BookingComponentList(viewModel: BookingComponentListViewModelMock())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

protocol BookingComponentListViewModelProtocol: ObservableObject {
    var workshopDisplayImageURL: URL? { get }
    var workshopName: String { get }
    var motorcycleModelName: String { get }
    var typeOfService: String { get }
    var schedule: String { get }
    var isLoading: Bool { get }
    func viewOnAppear()
}

final class BookingComponentListViewModelMock: BookingComponentListViewModelProtocol {
    var workshopDisplayImageURL: URL? {
        URL(string: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg")
    }
    var workshopName: String {
        "Berkat Jaya Motor"
    }
    var motorcycleModelName: String {
        "Yamaha Aerox 155"
    }
    var typeOfService: String {
        "Servis Rutin"
    }
    var schedule: String {
        "Kamis, 24 Februari 2022 – 12:00"
    }

    var isLoading: Bool {
        false
    }

    func viewOnAppear() {
        // noop
    }
}
