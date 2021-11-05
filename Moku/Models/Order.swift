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
    let bengkelId: String
    let customerId: String
    let motorId: String
    let typeOfService: Service
    var status: Status = .waitingConfirmation
    var notes: String?

    let schedule: Date
    let createdAt: Date

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
        case waitingConfirmation = "Menunggu konfirmasi"
        case waitingSchedule = "Menunggu penjadwalan"
        case onProgress = "Dalam progres"
        case rejected = "Ditolak"
        case done = "Selesai"
    }

    enum Service: String, Codable {
        case servisRutin = "Servis Rutin"
        case perbaikan = "Perbaikan"
    }
}
