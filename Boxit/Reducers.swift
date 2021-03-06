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
                    selectedUserState: selectedUserReducer(previous, event),
                    productState: productsReducer(previous.productState, event),
                    favouritesState: favouritesReducer(previous.favouritesState, event),
                    tutorialState: tutorialReducer(previous.tutorialState, event))
}

func loginReducer (_ previous: LoginState, _ event: Event) -> LoginState {
    var state = previous
    state.error = nil
    
    switch event {
    case .loadingLoginData:
        state.isLoading = true
        break
    case .checkedLoginState(let token, let ownId, let error):
        state.token = token
        state.ownId = ownId
        state.error = error
        state.isLoading = false
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
    case .markCurrentUserAsLoaded:
        state.currentUserState.alreadyLoaded = true
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

func selectedUserReducer (_ previous: AppState, _ event: Event) -> SelectedUserState {
    var state = previous
    
    switch event {
    case .selectUser(let user):
        state.selectedUserState.user = user
        if let ownId = state.loginState.ownId, let userId = user?.id, ownId == userId {
            state.selectedUserState.isSelf = true
        } else {
            state.selectedUserState.isSelf = false
        }
        break
    default:
        // do nothing
        break
    }
    
    return state.selectedUserState
}

func productsReducer (_ previous: ProductState, _ event: Event) -> ProductState {
    var state = previous
    state.error = nil
    state.isLoading = false
    
    switch event {
    case .loadingProductsData:
        state.isLoading = state.products.count == 0 ? true : false
        break
    case .resetProducts:
        state.products = []
        break
    case .updatePriceRange(let min, let max):
        state.products = []
        state.minPrice = min
        state.maxPrice = max
        break
    case .gotProducts(let products, let error):
        state.products += products
        state.error = error
        break
    case .startSavingProduct(let asin):
        let product = state.products.filter { prod -> Bool in prod.asin == asin }.first
        product?.isFavourite = true
        break
    case .revertSavingProduct(let asin):
        let product = state.products.filter { prod -> Bool in prod.asin == asin }.first
        product?.isFavourite = false
        break
    case .commitSavingProduct:
        // do nothing
        break
    case .startDeletingProduct(let asin):
        let product = state.products.filter { prod -> Bool in prod.asin == asin }.first
        product?.isFavourite = false
        break
    case .revertDeletingProduct(let asin):
        let product = state.products.filter { prod -> Bool in prod.asin == asin }.first
        product?.isFavourite = true
        break
    case .commitDeletingProduct:
        // do nothing
        break
    default:
        // do nothing
        break
    }
    
    return state
}

func favouritesReducer (_ previous: FavouritesState, _ event: Event) -> FavouritesState {
    var state = previous
    state.error = nil
    state.isLoading = false
    
    switch event {
    case .loadingFavouritesData:
        state.isLoading = true
        break
    case .gotFavourites(let products, let error):
        state.products = products
        state.error = error
        break
    case .startDeletingProduct(let asin):
        let product = state.products.filter { prod -> Bool in prod.asin == asin }.first
        product?.isFavourite = false
        break
    case .revertDeletingProduct(_):
        // do nothing
        break
    case .commitDeletingProduct:
        // do nothing
        break
    default:
        // do nothing
        break
    }
    
    return state
}

func tutorialReducer (_ previous: TutorialState, _ event: Event) -> TutorialState {
    
    var state = previous
    let step = state.currentStep
    
    switch event {
    case .showTutorial:
        state.hasTutorial = true
        break
    case .advanceTutorial:
        switch step {
        case .Initial:
            state.currentStep = .Step1
            break
        case .Step1:
            state.currentStep = .Step2
            break
        case .Step2:
            state.currentStep = .Step3
            break
        case .Step3:
            state.currentStep = .Done
            break
        default:
            // do nothing
            break
        }
    default:
        // do nothing
        break
    }
    
    return state
}
