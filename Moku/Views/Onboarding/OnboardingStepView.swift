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
//        GeometryReader { gp in
//            ZStack {
//                Text(data.image).font(.title)
//                    .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.bottom] })
//                    .position(x: gp.size.width / 2, y: gp.size.height / 2)
//                Text(data.heading).font(.title3)
//                    .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.top] - 50 })
//                    .multilineTextAlignment(TextAlignment.center)
//                    .foregroundColor(Color("PrimaryColor"))
//                Text(data.text).font(.caption)
//                    .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.top] - 48 })
//                    .multilineTextAlignment(TextAlignment.center)
//            }
//        }.padding(.horizontal)
        VStack(alignment: .center) {
            Text(data.image).font(.title)
            Text(data.heading).font(.title3).multilineTextAlignment(TextAlignment.center).foregroundColor(Color("PrimaryColor")).padding(.top, 300).padding(.bottom)
            Text(data.text).font(.body).multilineTextAlignment(TextAlignment.center)

        }.padding(.horizontal, 25)
    }
}

//struct OnboardingStepView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingStepView()
//    }
//}
