//
//  NavigationHelper.swift
//  Moku
//
//  Created by Dicky Buwono on 23/11/21.
//

import Foundation
import SwiftUI

struct NavigateToRootView {
  static func popToRootView() {
    let scenes = UIApplication.shared.connectedScenes
    let windowScenes = scenes.first as? UIWindowScene
    findNavigationController(viewController: windowScenes?.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}
