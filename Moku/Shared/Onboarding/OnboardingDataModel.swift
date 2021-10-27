//
//  OnboardingDataModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import Foundation

struct OnboardingDataModel {
    var image: String
    var heading: String
    var text: String
}

extension OnboardingDataModel {
    static var data: [OnboardingDataModel] = [
        OnboardingDataModel(
            image: "image1",
            heading: "Cari bengkel terbaik disekitarmu",
            text: "Kamu bisa melihat bengkel-bengkel disekitarmu dan bisa memilih bengkel dengan rating terbaik untuk motormu"
        ),
        OnboardingDataModel(
            image: "image2",
            heading: "Booking Bengkel Favoritmu!",
            text: "Hindari antiran yang lama saat melakukan servis di bengkel favoritmu dengan melakukan booking di aplikasi Moku"
        ),
        OnboardingDataModel(
            image: "image3",
            heading: "Cek riwayat servismu",
            text: "Kamu bisa melihat riwayat servis motormu sehingga performa motormu bisa tetap optimal"
        ),
    ]
}
