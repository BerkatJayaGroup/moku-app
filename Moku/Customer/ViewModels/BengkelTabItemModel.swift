//
//  BengkelTabItemModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Combine

extension BengkelTabItem {
    class ViewModel: ObservableObject {
        @Published var currentLocation = "Loading..."
        @Published var selectedMotor: Motor?
        @Published var isCustomer = false
        @Published var nearbyBengkel = [Bengkel]()

        var customerMotors = [Motor]()

        private var subscriptions = Set<AnyCancellable>()

        @Published var customer: Customer?

        @Published var searchQuery = ""

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
            getNearestBengkel()

            $selectedMotor.sink { [self] motor in
                self.getNearestBengkel(for: motor?.brand)
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
                    selectedMotor = customerMotors.first
                default:
                    isCustomer = false
                }
            }.store(in: &subscriptions)
        }

        private func getLocation() {
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocode(coordinate: coordinate) { location in
                    self.currentLocation = location
                }
            }.store(in: &subscriptions)
        }

        func getNearestBengkel(for brand: Brand? = nil) {
            nearbyBengkel = MapHelper.findNearbyBengkel(from: LocationService.shared.userCoordinate, filter: brand)
        }
    }
}
