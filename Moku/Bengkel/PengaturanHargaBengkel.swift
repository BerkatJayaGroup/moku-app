//
//  PengaturanHargaBengkel.swift
//  Moku
//
//  Created by Dicky Buwono on 27/10/21.
//

import SwiftUI

struct PengaturanHargaBengkel: View {
    @State private var min: String = ""
    @State private var max: String = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Masukkan harga jasa service rutin, umumnya service rutin mencakup jasa pengecekan mesin, busa filter, pengecekan komponen ban, lampu, rantai, dan lainnya.")
                    .font(.system(size: 13))
                    .padding(.bottom)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                HStack {
                    TextField("Rp minimum", text: $min)
                        .font(.system(size: 15))
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(9)
                        .keyboardType(.numberPad)
                    Text("-")
                    TextField("Rp maksimum", text: $max)
                        .font(.system(size: 15))
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(9)
                        .keyboardType(.numberPad)
                }.padding()
                Spacer()
                Text("Harga yang Anda masukkan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                Button {
                    
                }label: {
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
