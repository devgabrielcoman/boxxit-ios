//
//  Reducers.swift
//  Boxxit
//
//  Created by Gabriel Coman on 30/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

func appReducer (_ previous: AppState, _ event: Event) -> AppState {
    return AppState(loginState: loginReducer(previous.loginState, event))
}

func loginReducer (_ previous: LoginState, _ event: Event) -> LoginState {
    var state = previous
    state.isLoading = false
    state.error = nil
    
    switch event {
    case .loadingLoginData:
        state.isLoading = true
        break
    case .checkedLoginState(let token, let ownId, let error):
        state.token = token
        state.ownId = ownId
        state.error = error
        break
    default:
        // do nothing
        break
    }
    
    return state
}
