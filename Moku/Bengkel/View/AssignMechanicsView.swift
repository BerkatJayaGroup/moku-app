//
//  AssignMechanicsView.swift
//  Moku
//
//  Created by Mac-albert on 15/11/21.
//

import SwiftUI
import PartialSheet
import HalfASheet

struct AssignMechanicsView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @State var showMechanics: Bool = true
    var body: some View {
        Button(action: {
            print("Call Modal")
        }, label: {
            Text("Show Sheet")
        })
    }
}

struct AssignMechanicsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignMechanicsView()
    }
}
