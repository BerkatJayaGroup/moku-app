//
//  Date.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct DateStack: View {
    var date: BookDate = BookDate(day: "Wed", dayNumber: "03", month: "11", year: "20")
    var isSelected: Bool
    var onSelect: ((BookDate) -> Void) = {_ in }

    var body: some View {
        VStack {
            Text("\(date.day)")
                .font(.system(size: 11))
                .bold()
                .foregroundColor(isSelected ? .white : .black)

            Text("\(date.dayNumber)")
                .font(.system(size: 20))
                .bold()
                .foregroundColor(isSelected ? .white : .black)

        }
            .frame(width: 45, height: 60)
            .background( isSelected ? AppColor.primaryColor : Color.white)
            .cornerRadius(10)
            .onTapGesture {
                self.onSelect(self.date)
        }
    }
}

struct DateStack_Previews: PreviewProvider {
    static var previews: some View {
        DateStack(isSelected: false)
    }
}
