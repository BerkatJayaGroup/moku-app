//
//  SparepartsListView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 29/11/21.
//

import SwiftUI

struct SparepartsListView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Binding var chosenSpareparts: [String]
    @State private var searchText = ""

    let spareparts = [
        "Oli",
        "Kampas Rem",
        "Busi"
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBarComponent(text: $searchText)
                List(searchText.isEmpty ? spareparts : spareparts.filter({ $0.lowercased().contains(searchText.lowercased()) }), id: \.self) { sparepart in
                    HStack {
                        Button(sparepart) {
                            if !chosenSpareparts.contains(sparepart) {
                                chosenSpareparts.append(sparepart)
                            } else {
                                if let index = chosenSpareparts.firstIndex(of: sparepart) {
                                    chosenSpareparts.remove(at: index)
                                }
                            }
                        }
                        Spacer()
                        if chosenSpareparts.contains(sparepart) {
                            Image(systemName: .checkmark).foregroundColor(AppColor.primaryColor)
                        }
                    }
                }
                .listStyle(.plain)
            }.navigationTitle("Suku cadang")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Simpan") {
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.vertical)
                .navigationBarColor(AppColor.primaryColor)
        }
    }
}
