//
//  PesananTabBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import SwiftUI

struct PesananTabBengkelView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    RactBg()
                        .frame(height: 104)
                        .foregroundColor(Color("PrimaryColor"))
                    VStack {
                        Spacer(minLength: 35)
                        HStack {
                            Text("Pesanan")
                                .foregroundColor(.white)
                                .font(.system(size: 34))
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    Review
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
}

struct PesananTabBengkelView_Previews: PreviewProvider {
    static var previews: some View {
        PesananTabBengkelView()
    }
}
