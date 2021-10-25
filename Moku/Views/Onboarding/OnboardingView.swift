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
        TabView(selection: $curSlideIndex) {
            ForEach(0..<data.count) { i in
                OnboardingStepView(data: data[i]).tag(i)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never)).foregroundColor(Color.primary)
        .onAppear {
            setupAppearance()
        }
        if curSlideIndex == data.count - 1 {
            Button("Daftar atau Masuk", action:{
                appState.hasOnboarded = true
            })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.horizontal)
            Button("Masuk ke halaman utama", action:{})
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("SalmonOrange"))
                .foregroundColor(Color("PrimaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.horizontal)
        } else {
            Button("Selanjutnya", action:{ self.curSlideIndex += 1 })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.horizontal)
            Button("Lewati", action:{ self.curSlideIndex = data.count - 1 })
                .foregroundColor(.gray)
                .padding()
        }
    }
}
