//
//  OnboardingStepView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import SwiftUI

struct OnboardingStepView: View {

    var data: OnboardingDataModel
  var proxy: GeometryProxy

    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .maxWidth(proxy.size.width/1.9)
            Text(data.heading).font(.title3, weight: .semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("PrimaryColor"))
                .padding(.top, 40)
                .padding(.bottom)
            Text(data.text).font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(AppColor.darkGray)
        }.padding(.horizontal, 25)
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var previews: some View {
      GeometryReader { proxy in
        OnboardingStepView(data: OnboardingDataModel(
            image: "Onboard3",
            heading: "Cari bengkel terbaik disekitarmu",
            text: "Kamu bisa melihat bengkel-bengkel disekitarmu dan bisa memilih bengkel dengan rating terbaik untuk motormu"), proxy: proxy)
      }
    }
}
