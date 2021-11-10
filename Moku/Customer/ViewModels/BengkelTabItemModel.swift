//
//  BengkelTabItemModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Combine
import SwiftUI

extension BengkelTabItem {
    class ViewModel: ObservableObject {
        @ObservedObject var sessionService = SessionService.shared
        @Published var currentLocation = "Loading..."
        @Published var isCustomer = false

        var customerMotors = [Motor]()

        private var subscriptions = Set<AnyCancellable>()

        @Published var customer: Customer?

        @Published var searchQuery = ""

        @Published var locationQuery = ""

        @Published var nearbyBengkel = [Bengkel]()
        
        @ObservedObject var orderRepository: OrderRepository = .shared

        var filteredNearbyBengkel: [Bengkel] {
            let query = searchQuery.lowercased().trimmingCharacters(in: .whitespaces)

            if query.isEmpty { return nearbyBengkel }

            return nearbyBengkel.filter { bengkel in
                bengkel.name.lowercased().contains(query) || bengkel.address.lowercased().contains(query)
            }
        }

        init() {
            getMotors()
            getLocation()
//            getNearbyBengkel(for: selectedMotor?.brand)

            sessionService.$selectedMotor.sink { motor in
                self.nearbyBengkel = MapHelper.findNearbyBengkel(
                    from: LocationService.shared.userCoordinate,
                    filter: motor?.brand
                )
            }.store(in: &subscriptions)

            LocationService.shared.$userCoordinate.sink { [self] coordinate in
                nearbyBengkel = MapHelper.findNearbyBengkel(from: coordinate, filter: sessionService.selectedMotor?.brand)
            }.store(in: &subscriptions)

            // Update everytime both the location and bengkel database changes
            Publishers.Zip(
                LocationService.shared.$userCoordinate,
                BengkelRepository.shared.$bengkel
            ).sink { [self] coordinate, bengkel in
                nearbyBengkel = MapHelper.findNearbyBengkel(
                    data: bengkel,
                    from: coordinate,
                    filter: sessionService.selectedMotor?.brand
                )
            }.store(in: &subscriptions)
        }

        private func getMotors() {
            SessionService.shared.$user.sink { [self] user in
                switch user {
                case .customer(let customer):
                    isCustomer = true
                    self.customer = customer
                    if let motors = customer.motors {
                        customerMotors = motors
                    }
                    sessionService.selectedMotor = customerMotors.first
                default:
                    isCustomer = false
                }
            }.store(in: &subscriptions)
        }

        private func getLocation() {
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocodeCity(coordinate: coordinate) { location in
                    self.currentLocation = location
                }
            }.store(in: &subscriptions)
        }
    }
}
