//
//  BengkelDetailViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import UIKit

class BengkelDetailViewModel: ObservableObject {
    @Published var bengkel: Bengkel

    // MARK: UI State
    @Published var activeNavigationLink: ActiveNavigationLink?
    @Published var isFavorite = false
    @Published var isOperatinalHoursSheetShowing = false
    @Published var typeOfService: Order.Service = .servisRutin
    @Published var uiTabarController: UITabBarController?

    // MARK: Bengkel Properties
    @Published var address: String?

    var workshopPhoto: String? {
        bengkel.photos.first
    }

    var distance: String {
        MapHelper.stringify(distance: bengkel.distance)
    }

    var operationalHours: String {
        StringHelper.stringifyOperationalHours(bengkel.operationalHours)
    }

    var priceRange: String {
        bengkel.minPrice.toCurrencyFormat() + "-" + bengkel.maxPrice.toCurrencyFormat()
    }

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
        setupViewModel()
    }

    func setupViewModel() {
        getFavoriteStatus()
        geocodeAddress()
    }

    private func getFavoriteStatus() {
        guard case .customer(let customer) = SessionService.shared.user else { return }
        if customer.favoriteBengkel.contains(where: { $0.name == bengkel.name }) {
            isFavorite = true
        }
    }

    private func geocodeAddress() {
        MapHelper.geocodeAddress(coordinate: bengkel.coordinate) { [self] result in
            // Fallback address incase no result found
            guard let result = result else {
                return address = bengkel.address
            }

            address = result.address
        }
    }

    func toggleFavorite() {
        if isFavorite {
            guard case .customer(var customer) = SessionService.shared.user,
                  let workshopToUnfavoriteIndex = customer.favoriteBengkel.firstIndex(where: { $0.id == bengkel.id })
            else { return }
            customer.favoriteBengkel.remove(at: workshopToUnfavoriteIndex)
            CustomerRepository.shared.update(customer: customer) { _ in
                self.isFavorite = false
            }
        } else {
            guard case .customer(var customer) = SessionService.shared.user else { return }
            customer.favoriteBengkel.append(bengkel)
            CustomerRepository.shared.update(customer: customer) { _ in
                self.isFavorite = true
            }
        }
    }
}
