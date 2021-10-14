//
//  Order.swift
//  Moku
//
//  Created by Christianto Budisaputra on 13/10/21.
//

import Foundation

struct Order: Identifiable, Codable {
    
    let id = UUID()
    let bengkel: Bengkel
    let customer: Customer
    let motor: Motor
    let typeOfService: Service
    let schedule: Date
    var status: Status = .waitingConfirmation
    var notes: String?
}

extension Order {
    enum Status: String, Codable {
        case waitingConfirmation, waitingSchedule, onProgress, rejected, done
    }

    enum Service: String, Codable {
        case checkup, fix
    }
}
