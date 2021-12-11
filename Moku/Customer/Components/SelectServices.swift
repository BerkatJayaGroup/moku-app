//
//  SelectServices.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI

struct SelectServices: View {
    var serviceTitle: String
    var serviceIcon: String
    var servicePrice: String
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(serviceTitle).font(.subheadline).semibold()

            Image(serviceIcon)
                .resizable()
                .scaledToFill()
                .padding(.horizontal)

            Text(servicePrice).font(.caption).semibold()
        }
        .padding()
        .maxWidth(.infinity)
        .background(AppColor.primaryBackground.cornerRadius(24).applyShadow())
        .overlay(
            RoundedRectangle(cornerRadius: 24).stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
        )
    }
}
