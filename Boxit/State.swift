//
//  State.swift
//  Boxxit
//
//  Created by Gabriel Coman on 30/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

protocol ReduxState {}

struct AppState: ReduxState {
    var loginState: LoginState = LoginState()
//    var profiles: [String : FacebookProfile] = [:]
}

struct LoginState: ReduxState {
    var isLoading = false
    var token: String?
    var ownId: String?
}

