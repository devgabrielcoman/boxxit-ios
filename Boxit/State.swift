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
    var loginState = LoginState()
    var friendsState = FriendsState()
    var currentUserState = CurrentUserState()
    var selectedUserState = SelectedUserState()
    var productState = ProductState()
}

struct LoginState: ReduxState {
    var isLoading = false
    var token: String?
    var ownId: String?
    var error: BoxitError? = nil
}

struct CurrentUserState: ReduxState {
    var currentUser: FacebookProfile?
    var error: BoxitError? = nil
}

struct FriendsState: ReduxState {
    var isLoading: Bool = false
    var friends: [FacebookProfile] = []
    var error: BoxitError? = nil
    var offset: String? = nil
    var canStillAdd: Bool = false
}

struct SelectedUserState: ReduxState {
    var user: FacebookProfile?
    var isSelf: Bool = false
}

struct ProductState: ReduxState {
    var isLoading: Bool = false
    var products: [Product] = []
    var error: BoxitError? = nil
    var minProie: Int = 0
    var maxPrice: Int = 5000
}
