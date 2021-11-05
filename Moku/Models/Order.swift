//
//  Order.swift
//  Moku
//
//  Created by Christianto Budisaputra on 13/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Order: Codable {
    @DocumentID var id: String!
    let bengkel: Bengkel
    let customer: Customer
    let motor: Motor
    let typeOfService: Service
    var status: Status = .waitingConfirmation
    var notes: String?

    let schedule: Date
    let createdAt = Date()

    var cancelingReason: CancelingReason?
}

extension Order {
    enum CancelingReason: String, Codable {
        case bengkelTutup       = "Bengkel tutup"

        // MARK: Customer Side
        case bengkelLain        = "Ingin memilih bengkel lain"
        case tidakJadi          = "Tidak ingin melakukan perbaikan / servis"
        case ubahOrder          = "Ingin merubah detail / tanggal booking"

        // MARK: Bengkel Side
        case tidakMemilikiAlat  = "Tidak memiliki alat untuk tipe motor"
        case sparepartKosong    = "Sparepart tidak tersedia / kosong"
        case kurangMekanik      = "Bengkel kekurangan mekanik"
    }

    enum Status: String, Codable {
        case waitingConfirmation, waitingSchedule, onProgress, rejected, done
    }

    enum Service: String, Codable {
        case servisRutin = "Servis Rutin"
        case perbaikan = "Perbaikan"
    }
}

extension Order {
    static let preview = Order(
        bengkel: .preview,
        customer: .preview,
        motor: Motor(brand: .yamaha, model: "NMAX", cc: 155),
        typeOfService: .servisRutin,
        notes: "Lorem Ipsum.",
        schedule: Date(),
        createdAt: Date()
    )
}
