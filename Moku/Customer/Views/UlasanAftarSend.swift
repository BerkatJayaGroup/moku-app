//
//  UlasanAftarSend.swift
//  Moku
//
//  Created by Mac-albert on 12/11/21.
//

import SwiftUI

struct UlasanAftarSend: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 12){
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(AppColor.primaryColor)
                    .font(.system(size: 120))
                Text("Terimakasih atas Ulasanmu!")
                    .fontWeight(.semibold)
                Text("Ulasanmu berhasil disimpan dan akan dikirim kepada Bengkel")
            }
            .navigationTitle("Ulasan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Batal") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
