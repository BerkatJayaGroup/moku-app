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
                .foregroundColor(isSelected ? .white : .red)

            Text("\(date.dayNumber)")
                .font(.system(size: 20))
                .bold()
                .foregroundColor(isSelected ? .white : .red)
                .padding(.top, 10)

        }.padding()
            .frame(width: 60, height: 75)
            .background( isSelected ? Color.blue : Color.gray.opacity(0.3))
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
