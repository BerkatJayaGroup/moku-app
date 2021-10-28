//
//  UserDataKeychain.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 27/10/21.
//

import Foundation

struct UserDataKeychain: Keychain {
  // Make sure the account name doesn't match the bundle identifier!
  var account = "id.moku.Moku.SignInWithApple"
  var service = "userIdentifier"

  typealias DataType = UserData
}
