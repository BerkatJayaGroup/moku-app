// Copyright © 2020 Flinesoft. All rights reserved.

import SwiftUI

struct MultiSelector<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    let barTitle: String
    let proxy: GeometryProxy

    var selected: Binding<Set<Selectable>>
    @State var isBengkelProfile: Bool = false

    @State var isOpenSelector: Bool = false

    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) })
    }

    var body: some View {
        Button {
            isOpenSelector.toggle()
        } label: {
            HStack {
                Text(formattedSelectedListString)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 10)
                    .frame(width: proxy.size.width)
                    .background(Color(hex: "F3F3F3"))
                    .cornerRadius(8)
                Spacer()
            }
        }
        .sheet(isPresented: $isOpenSelector) {
            MultiSelectionView(showSheetView: $isOpenSelector,
                               options: options,
                               optionToString: optionToString,
                               barTitle: barTitle, isBengkelProfile: isBengkelProfile, selected: selected)
        }
    }
}
