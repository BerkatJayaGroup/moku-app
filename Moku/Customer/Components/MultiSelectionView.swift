import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var showSheetView: Bool
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    let barTitle: String
    @Binding var selected: Set<Selectable>

    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                Button {
                    selectAll(option: options)
                }label: {
                    Text("Pilih Semua")
                }
                .padding(.trailing)
                .padding(.top)
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
                            .frame(height: 30)
                            Divider().background(AppColor.lightGray)
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
                .navigationBarTitle(barTitle, displayMode: .inline)
                .navigationBarItems(trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Simpan")
                })
            }.onAppear {
                UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            }
        }
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }

    private func selectAll(option: [Selectable]) {
        selected = Set(options)
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }

    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })

    static var previews: some View {
        NavigationView {
            MultiSelectionView(
                showSheetView: .constant(true),
                options: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                optionToString: { $0.string },
                barTitle: "Brand", selected: $selected
            )
        }
    }
}
