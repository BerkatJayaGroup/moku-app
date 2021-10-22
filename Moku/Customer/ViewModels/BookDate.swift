//
//  BookDate.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import Foundation

struct BookDate: Equatable {
    var day: String
    var dayNumber: String
    var month: String
    var year: String

    static var `default`: BookDate { BookDate(day: "", dayNumber: "", month: "", year: "") }

}
