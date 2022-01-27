//
//  ColorExtension.swift
//  Moku
//
//  Created by Mac-albert on 24/01/22.
//

import Foundation
import SwiftUI

struct ColorButton {

    static func getColors(status: Order.Status) -> some View {
        switch status {
        case .waitingConfirmation:
            return Color(hex: "BFE0F4")
        case .scheduled:
            return Color(hex: "F8D8BF")
        case .rejected:
            return Color(hex: "FFBDBD")
        case .done:
            return Color(hex: "DCDCDC")
        case .onProgress:
            return Color(hex: "BFF8D8")
        default:
            return Color(hex: "F8D8BF")
        }
    }

    static func getFontColors(status: Order.Status) -> some View {
        switch status {
        case .waitingConfirmation:
            return Color(hex: "0086D4")
        case .scheduled:
            return Color(hex: "E46400")
        case .rejected:
            return Color(hex: "E40000")
        case .done:
            return Color(hex: "686868")
        case .onProgress:
            return Color(hex: "007133")
        default:
            return AppColor.primaryColor
        }
    }
}
