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
                    friendsState: friendsReducer(previous.friendsState, event),
                    currentUserState: currentUserReducer(previous, event),
                    selectedUser: selectedUserReducer(previous.selectedUser, event),
                    productState: productsReducer(previous.productState, event))
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

func currentUserReducer (_ previous: AppState, _ event: Event) -> CurrentUserState {
    var state = previous
    state.currentUserState.error = nil
    
    switch event {
    case .gotUser(_, let user, let error):
        if let sId = user?.id, sId == previous.loginState.ownId {
            state.currentUserState.currentUser = user
        }
        state.currentUserState.error = error
        break
    default:
        // do nothing
        break
    }
    
    return state.currentUserState
}

func friendsReducer (_ previous: FriendsState, _ event: Event) -> FriendsState {
    var state = previous
    state.error = nil
    state.isLoading = false
    state.canStillAdd = false
    
    switch event {
    case .loadingFriendsData:
        state.isLoading = true
        break
    case .gotFriends(let friends, let offset, let error):
        state.friends += friends
        state.offset = offset
        state.error = error
        state.canStillAdd = offset != nil && friends.count > 0
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
    case .selectUser(let user):
        state = user
        break
    default:
        // do nothing
        break
    }
    
    return state
}

func productsReducer (_ previous: ProductState, _ event: Event) -> ProductState {
    var state = previous
    state.error = nil
    state.isLoading = false
    
    switch event {
    case .loadingProductsData:
        state.isLoading = true
        break
    case .gotProducts(let products, let error):
        state.products = products
        state.error = error
        break
    default:
        // do nothing
        break
    }
    
    return state
}
