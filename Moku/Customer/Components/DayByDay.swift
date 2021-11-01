//
//  DayByDay.swift
//  Moku
//
//  Created by Mac-albert on 02/11/21.
//

import SwiftUI

struct DayByDay: View {
    var day: String
    var time: String
    var body: some View{
        HStack{
            Image(systemName: "calendar")
                .font(.system(size: 40))
            VStack{
                Text(day)
                    .font(.system(size: 15))
                Text(time)
                    .font(.system(size: 13))
            }
            Spacer()
        }
    }
}

struct DayByDay_Previews: PreviewProvider {
    static var previews: some View {
        DayByDay(day: "Senin", time: "10.00-17.00")
    }
}
