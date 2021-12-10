//
//  BengkelTabItemModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Combine
import CoreLocation
import SwiftUI

extension BengkelTabItem {
    class ViewModel: ObservableObject {
        @ObservedObject var sessionService = SessionService.shared

        @Published private var selectedMotorcycle: Motor?

        @Published var currentLocation: String?
        @Published var ordersToRate = [Order]()

        @Published var banners = [PromotionalBanner]()
        @Published var activeBannerIndex = 0

        @Published var nearbyWorkshops = [Bengkel]()
        @Published var favouriteWorkshops = [Bengkel]()

        @Published var activeSheet: ActiveSheet?
        @Published var isChoosingMotor = false

        var availableMotors = [Motor]()

        var selectedMotorcycleModel: String? {
            guard let selectedMotorcycle = selectedMotorcycle else {
                return nil
            }

            return "\(selectedMotorcycle.brand.rawValue) \(selectedMotorcycle.model)"
        }

        private var subscriptions = Set<AnyCancellable>()

        init() {
            assignDefaultSelectionForMotorcycle()
            subscribeToPromotionalBannersChanges()
            subscribeToUserLocationChanges()
            subscribeToSelectedMotorChanges()
            subscribeToUserChanges()
        }

        deinit {
            subscriptions.forEach { subscription in
                subscription.cancel()
            }
        }

        private func subscribeToPromotionalBannersChanges() {
            PromotionalBannerRepository.shared.$banners.sink { banners in
                self.banners = banners
            }.store(in: &subscriptions)
        }

        private func assignDefaultSelectionForMotorcycle() {
            guard case .customer(let customer) = sessionService.user,
                  let availableMotorcycles = customer.motors,
                  let firstMotorcycle = availableMotorcycles.first
            else { return }
            selectedMotorcycle = firstMotorcycle
        }

        private func subscribeToUserLocationChanges() {
            guard case .customer(_) = sessionService.user else { return }
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocodeCity(coordinate: coordinate) { shortAddress in
                    self.currentLocation = shortAddress
                }
                // Fetch nearby workshops
                self.nearbyWorkshops = MapHelper.findNearbyBengkel(
                    from: coordinate,
                    filter: self.selectedMotorcycle?.brand
                )
            }.store(in: &subscriptions)
        }

        private func subscribeToSelectedMotorChanges() {
            sessionService.$selectedMotor.sink { motor in
                self.nearbyWorkshops = MapHelper.findNearbyBengkel(
                    from: LocationService.shared.userCoordinate,
                    filter: motor?.brand
                )
                if let motor = motor {
                    self.selectedMotorcycle = motor
                }
            }.store(in: &subscriptions)

            $isChoosingMotor.sink { choosing in
                if !choosing, self.activeSheet != nil {
                    self.activeSheet = nil
                }
            }.store(in: &subscriptions)
        }

        private func subscribeToUserChanges() {
            sessionService.$user.sink { [self] user in
                if case .customer(let customer) = user {
                    if let availableMotors = customer.motors {
                        self.availableMotors = availableMotors
                    }

                    favouriteWorkshops = customer.favoriteBengkel
                    mapOrdersToRateIfNeeded(orderIDs: customer.ordersToRate)
                }
            }.store(in: &subscriptions)
        }

        private func mapOrdersToRateIfNeeded(orderIDs: [String]?) {
            ordersToRate = []
            orderIDs?.forEach { orderID in
                OrderRepository.shared.fetch(orderID: orderID) { order in
                    self.ordersToRate.append(order)
                }
            }
        }

        func showChooseLocationTray() {
            activeSheet = .location
        }

        func showChooseMotorTray() {
            activeSheet = .motor
            isChoosingMotor = true
        }

        func updateLocation(_ location: Location) {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                    longitude: location.longitude)
            MapHelper.geocodeCity(coordinate: coordinate) { [self] shortAdress in
                currentLocation = shortAdress
            }
        }
    }
}
