//
//  StringExtension.swift
//  Moku
//
//  Created by Dicky Buwono on 26/11/21.
//

import SwiftUI

extension String {
     func toCurrencyFormat() -> String {
        if let intValue = Int(self) {
           let numberFormatter = NumberFormatter()
           numberFormatter.locale = Locale(identifier: "id_ID")
           numberFormatter.numberStyle = NumberFormatter.Style.currency
           return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
      }
    return ""
  }
}
