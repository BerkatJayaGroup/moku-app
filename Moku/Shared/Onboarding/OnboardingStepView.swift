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
        VStack() {
            Text(data.image).font(.title)
            Text(data.heading).font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("PrimaryColor"))
                .padding(.top, 300)
                .padding(.bottom)
            Text(data.text).font(.body)
                .multilineTextAlignment(.center)
        }.padding(.horizontal, 25)
    }
}
