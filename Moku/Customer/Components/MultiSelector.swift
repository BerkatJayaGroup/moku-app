// Copyright © 2020 Flinesoft. All rights reserved.

import SwiftUI

struct MultiSelector<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    
    var selected: Binding<Set<Selectable>>
    
    @State var isOpenSelector: Bool = false
    
    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) })
    }
    
    var body: some View {
        Button(action: {
            self.isOpenSelector.toggle()
        }){
            HStack {
                Text(formattedSelectedListString)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                Spacer()
            }
        }
        .sheet(isPresented: $isOpenSelector){
            MultiSelectionView(showSheetView: $isOpenSelector,
                               options: options,
                               optionToString: optionToString,
                               selected: selected)
        }
    }
}
