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
        case .scheduled: return Color(hex: "F8D8BF")
        case .rejected: return Color(hex: "FFBDBD")
        case .done: return Color(hex: "DCDCDC")
        default: return Color(hex: "F8D8BF")
        }
    }

    static func getFontColors(status: Order.Status) -> some View {
        switch status {
        case .scheduled:
            return AppColor.primaryColor
        case .rejected:
            return Color.red
        case .done:
            return Color(hex: "686868")
        default:
            return AppColor.primaryColor
        }
    }
}
