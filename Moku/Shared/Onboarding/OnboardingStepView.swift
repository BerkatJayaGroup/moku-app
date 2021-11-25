//
//  OnboardingStepView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import SwiftUI

struct OnboardingStepView: View {

    var data: OnboardingDataModel

    var body: some View {
        VStack {
            Text(data.image).font(.title)
            Text(data.heading).font(.title3,weight: .semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("PrimaryColor"))
                .padding(.top, 300)
                .padding(.bottom)
            Text(data.text).font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(AppColor.darkGray)
        }.padding(.horizontal, 25)
    }
}
