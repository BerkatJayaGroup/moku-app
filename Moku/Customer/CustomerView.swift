//
//  CustomerView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI

enum Tabs {
    case tab1, tab2, tab3
}

struct CustomerView: View {
    @State var tabSelection: Tabs = .tab1

    init() {
        let appearance                                  = UITabBarAppearance()
        UITabBar.appearance().isTranslucent             = true
        UITabBar.appearance().backgroundColor           = UIColor(AppColor.grayTab)
        appearance.shadowColor                          = UIColor.gray

        let coloredAppearance                           = UINavigationBarAppearance()
        coloredAppearance.backgroundColor               = UIColor(AppColor.primaryColor)
        coloredAppearance.titleTextAttributes           = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes      = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor          = UIColor(AppColor.primaryColor)
    }

    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                BengkelTabItem(tab: $tabSelection)
                    .tabItem {
                        Image(systemName: "wrench.and.screwdriver.fill")
                        Text("Bengkel")
                    }
                    .tag(Tabs.tab1)
                    .navigationBarHidden(returnNavbarHide(tabSelection: self.tabSelection))
                BookingsTabItem()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Booking")
                    }
                    .tag(Tabs.tab2)
                    .navigationBarHidden(returnNavbarHide(tabSelection: self.tabSelection))
                GarasiTabItem()
                    .tabItem {
                        Image(systemName: "bicycle")
                        Text("Garasi")
                    }
                    .tag(Tabs.tab3)
                   .navigationBarHidden(returnNavbarHide(tabSelection: self.tabSelection))
            }
            .accentColor(AppColor.primaryColor)
            .navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    func returnNaviBarTitle(tabSelection: Tabs) -> String {
        switch tabSelection {
        case .tab1: return ""
        case .tab2: return "Bookings"
        case .tab3: return "Garasi"
        }
    }

    func returnNavbarHide(tabSelection: Tabs) -> Bool {
        switch tabSelection {
        case .tab1:
            return true
        case .tab2:
            return false
        case .tab3:
            return false
        }
    }
}
