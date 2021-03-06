//
//  TimeStack.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct TimeStack: View {
    var index: Int
    var isSelected: Bool
    var isDisabled = false
    var onSelect: ((Int) -> Void) = {_ in }
    var body: some View {
        Text("\(index):00")
            .frame(width: 50, height: 30)
            .foregroundColor(isDisabled ? Color.white : isSelected ? .white : AppColor.darkGray)
            .padding(5)
            .background(isDisabled ? AppColor.darkGray : isSelected ? AppColor.primaryColor : AppColor.lightGray)
            .cornerRadius(10).onTapGesture {
                if !isDisabled {
                    self.onSelect(self.index)
                }
            }
    }
}

struct TimeStack_Previews: PreviewProvider {
    static var previews: some View {
        TimeStack(index: 0, isSelected: false)
    }
}
