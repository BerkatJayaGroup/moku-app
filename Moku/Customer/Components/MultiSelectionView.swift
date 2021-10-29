import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var showSheetView: Bool
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: Set<Selectable>

    var body: some View {
        NavigationView {
            List {
                ForEach(options) { selectable in
                    Button {
                        toggleSelection(selectable: selectable)
                    } label: {
                        HStack {
                            Text(optionToString(selectable)).foregroundColor(.black)
                            Spacer()
                            if selected.contains { $0.id == selectable.id } {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                    }.tag(selectable.id)
                }
            }
            .navigationBarItems(leading: Button {
                self.showSheetView = false
            } label: {
                Image(systemName: "chevron.left")
                Text("Kembali")
            })
            .listStyle(GroupedListStyle())
        }
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}

// struct MultiSelectionView_Previews: PreviewProvider {
//    struct IdentifiableString: Identifiable, Hashable {
//        let string: String
//        var id: String { string }
//    }
//
//    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })
//
//    static var previews: some View {
//        NavigationView {
//            MultiSelectionView(
//                options: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
//                showSheetView: <#Binding<Bool>#>,
//                optionToString: { $0.string },
//                selected: $selected
//            )
//        }
//    }
// }