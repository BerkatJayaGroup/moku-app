//
//  OnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State var curSlideIndex = 0

    var data: [OnboardingDataModel]

    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("PrimaryColor"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }

    var body: some View {
      GeometryReader { proxy in
        VStack {
            TabView(selection: $curSlideIndex) {
                ForEach(0..<data.count) { i in
                  OnboardingStepView(data: data[i], proxy: proxy).tag(i)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never)).foregroundColor(Color.primary)
            .onAppear {
                setupAppearance()
            }
            if curSlideIndex == data.count - 1 {
                SignInWithAppleToFirebase({ response in
                    if response == .success {
                       print("logged into Firebase through Apple!")
                       appState.hasOnboarded = true
                    } else if response == .error {
                       print("error. Maybe the user cancelled or there's no internet")
                    }
                })
                    .frame(height: 50, alignment: .center)
                    .padding(.horizontal)
                Button("Masuk ke halaman utama", action: {
                    appState.hasOnboarded = true
                })
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("SalmonOrange"))
                    .foregroundColor(Color("PrimaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .padding(.horizontal)
            } else {
                Button {
                    self.curSlideIndex += 1
                }label: {
                    Text("Selanjutnya")
                        .font(.system(size: 17), weight: .semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                }.padding(.horizontal)
                Button {
                    self.curSlideIndex = data.count - 1
                }label: {
                    Text("Lewati")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }.padding(.bottom)
      }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(data: OnboardingDataModel.data)
    }
}
