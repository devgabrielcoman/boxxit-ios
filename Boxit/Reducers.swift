//
//  Reducers.swift
//  Boxxit
//
//  Created by Gabriel Coman on 30/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

func appReducer (_ previous: AppState, _ event: Event) -> AppState {
    return AppState(loginState: loginReducer(previous.loginState, event),
                    profilesState: profilesReducer(previous.profilesState, event),
                    currentUser: currentUserReducer(previous, event),
                    selectedUser: selectedUserReducer(previous.selectedUser, event))
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

func profilesReducer (_ previous: ProfilesState, _ event: Event) -> ProfilesState {
    var state = previous
    state.error = nil
    
    switch event {
    case .gotUser(let userId, let user, let error):
        state.profiles[userId] = user
        state.error = error
        break
    default:
        // do nothing
        break
    }
    
    return state
}

func selectedUserReducer (_ previous: FacebookProfile?, _ event: Event) -> FacebookProfile? {
    var state = previous
    
    switch event {
    case .gotUser(_, let user, _):
        state = user
        break
    default:
        // do nothing
        break
    }
    
    return state
}

func currentUserReducer (_ previous: AppState, _ event: Event) -> FacebookProfile? {
    var state = previous
    
    switch event {
    case .gotUser(_, let user, _):
        if let sId = user?.id, sId == previous.loginState.ownId {
            state.currentUser = user
        }
        break
    default:
        // do nothing
        break
    }
    
    return state.currentUser
}
