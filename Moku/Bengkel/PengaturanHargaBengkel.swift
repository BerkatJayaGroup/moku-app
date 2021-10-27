//
//  PengaturanHargaBengkel.swift
//  Moku
//
//  Created by Dicky Buwono on 27/10/21.
//

import SwiftUI

struct Brand: Identifiable {
    var id = UUID()
    @State var type = ""
    @State var min: String
    @State var max: String
}

struct Harga: Identifiable {
    var id = UUID()
    var name = ""
    var type = [
        Brand(type: "HONDA", min: "", max: ""),
        Brand(type: "YAMAHA", min: "", max: ""),
        Brand(type: "SUZUKI", min: "", max: "")
    ]
}

struct PengaturanHargaBengkel: View {
    @State private var tipeBaru = Harga()
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Masukkan harga jasa service rutin, umumnya service rutin mencakup jasa pengecekan mesin, busa filter, pengecekan komponen ban, lampu, rantai, dan lainnya.")
                    .font(.caption)
                    .padding(.bottom)
                    .foregroundColor(.gray)

                VStack(alignment: .leading) {
                    ForEach(self.tipeBaru.type) { item in
                        Text("\(item.type)")
                            .font(.caption)
                        HStack {
                            TextField("Rp minimum", text: item.$min)
                                .padding(10)
                                .background(Color(.systemGray5))
                                .cornerRadius(9)
                            Text("-")
                            TextField("Rp maksimum", text: item.$max)
                                .padding(10)
                                .background(Color(.systemGray5))
                                .cornerRadius(9)
                        }.padding(.bottom)

                    }
                }.padding()
                Spacer()
                Text("Harga yang Anda masukkan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {

                }) {

                    Text("Selesai")

                }
                .frame(width: 300, height: 45)
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }.padding()
                .navigationBarTitle("Pengaturan Harga", displayMode: .inline)
        }
    }
}

struct PengaturanHargaBengkel_Previews: PreviewProvider {
    static var previews: some View {
        PengaturanHargaBengkel()
    }
}
