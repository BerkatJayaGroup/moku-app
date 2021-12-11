//
//  StringHelper.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/12/21.
//

import Foundation

struct StringHelper {
    /// This function returns a string following `00:00` format.
    ///
    /// ```
    /// let x = formatHour(8) // 08:00
    /// let y = formatHour(16) // 16:00
    /// ```
    ///
    /// - Warning: The returned string is not localized.
    /// - Parameter hour: The hour to be formatted.
    /// - Returns: A formatted string depeding on the `hour`.
    private static func formatHour(_ hour: Int) -> String {
        let hour = String(format: "%02d", hour)
        return "\(hour):00"
    }

    static func stringifyOperationalHours(_ operationalHours: Bengkel.OperationalHours) -> String {
        let openingHour = formatHour(operationalHours.open)
        let closingHour = formatHour(operationalHours.close)

        return openingHour + "-" + closingHour
    }
}
