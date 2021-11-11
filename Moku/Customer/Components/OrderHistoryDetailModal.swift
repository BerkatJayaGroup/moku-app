//
//  OrderHistoryDetailModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 11/11/21.
//

import SwiftUI

struct OrderHistoryDetailModal: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct OrderHistoryDetailModal_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryDetailModal()
    }
}
