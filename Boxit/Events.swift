//
//  Event.swift
//  Boxxit
//
//  Created by Gabriel Coman on 30/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import FBSDKCoreKit
import Firebase

enum Event{
    case sideEffect
    case loadingLoginData
    case checkedLoginState(token: String?, ownId: String?, error: BoxitError?)
    case gotUser(forUserId: String, user: FacebookProfile?, error: BoxitError?)
    case markCurrentUserAsLoaded
    case loadingFriendsData
    case gotFriends(friends: [FacebookProfile], offset: String?, error: BoxitError?)
    case selectUser(user: FacebookProfile?)
    case loadingProductsData
    case resetProducts
    case updatePriceRange(withMin: Int, andMax: Int)
    case gotProducts(products: [Product], error: BoxitError?)
    case loadingFavouritesData
    case gotFavourites(products: [Product], error: BoxitError?)
    case startSavingProduct(asin: String)
    case revertSavingProduct(asin: String)
    case commitSavingProduct
    case startDeletingProduct(asin: String)
    case revertDeletingProduct(asin: String)
    case commitDeletingProduct
    case showTutorial
    case advanceTutorial
}

extension Event {
    
    static func checkLoginState () -> Observable<Event> {
        let profile = FBSDKProfile.current()
        let token = FBSDKAccessToken.current()

        var accessToken: String? = nil
        var ownId: String? = nil
        if let token = token {
            accessToken = token.tokenString
            ownId = token.userID
        }
        if let profile = profile {
            ownId = profile.userID
        }
        
        return Observable
            .just(Event.checkedLoginState(token: accessToken, ownId: ownId, error: nil))
            .startWith(Event.loadingLoginData)
    }
    
    static func loginUser (fromViewController controller: UIViewController) -> Observable<Event> {
        
        let request = FacebookAuthRequest(withViewController: controller)
        let task = FacebookAuthTask()
        return task.execute(withInput: request)
            .asObservable()
            .flatMap { token -> Observable<Void> in
                let request2 = NetworkRequest(withOperation: NetworkOperation.populateUserProfile(token: token))
                let task2 = NetworkTask()
                return task2.execute(withInput: request2).asObservable().map { value -> Void in return () }
            }
            .flatMap { _ -> Observable<Event> in
                return Event.checkLoginState()
            }
            .catchErrorJustReturn(Event.checkedLoginState(token: nil, ownId: nil, error: BoxitError.FbAuthError))
            .startWith(Event.loadingLoginData)
    }
    
    static func get(profileForUserId id: String) -> Observable<Event> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getProfileFromFacebook(forUser: id))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { fbData -> Single<FacebookProfile> in
                let task = ParseFacebookProfileTask()
                return task.execute(withInput: fbData)
            }
            .asObservable()
            .map { profile -> Event in
                return Event.gotUser(forUserId: id, user: profile, error: nil)
            }
            .catchErrorJustReturn(Event.gotUser(forUserId: id, user: nil, error: BoxitError.NoInternet))
    }
    
    static func get(friendFromNotification id: String) -> Observable<Event> {
        let request = NetworkRequest(withOperation: NetworkOperation.getProfileFromFacebook(forUser: id))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { fbData -> Single<FacebookProfile> in
                let task = ParseFacebookProfileTask()
                return task.execute(withInput: fbData)
            }
            .asObservable()
            .map { profile -> Event in
                return Event.selectUser(user: profile)
            }
            .catchErrorJustReturn(Event.selectUser(user: nil))
    }
    
    static func get(friendsForUserId id: String?, withOffset offset: String?) -> Observable<Event> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getFriendsFromFacebook(forUser: id!, offset: offset))
        let task = NetworkTask ()
        return task.execute(withInput: request)
            .flatMap { friendData -> Single<FacebookData<FacebookProfile>> in
                let task = ParseFacebookDataTask<FacebookProfile>()
                return task.execute(withInput: friendData)
            }
            .asObservable()
            .map { fbData -> Event in
                Event.gotFriends(friends: fbData.data, offset: fbData.offsetAfter, error: nil)
            }
            .catchErrorJustReturn(Event.gotFriends(friends: [], offset: nil, error: BoxitError.NoInternet))
            .startWith(Event.loadingFriendsData)
    }
    
    static func get(productsForUserid id: String, withMinPrice min: Int, andMaxPrice max: Int) -> Observable<Event> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getProductsForUser(id: id, min: min, max: max))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { productData -> Single<BackendData<Product>> in
                let task = ParseNetworkDataTask<Product>()
                return task.execute(withInput: productData)
            }
            .asObservable()
            .flatMap { data -> Observable<Product> in
                return Observable.from(data.data)
            }
            .toArray()
            .map { products -> Event in
                Event.gotProducts(products: products, error: nil)
            }
            .catchErrorJustReturn(Event.gotProducts(products: [], error: BoxitError.NoInternet))
            .startWith(Event.loadingProductsData)
    }
    
    static func get(favouriteProductsForUserId id: String) -> Observable<Event> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getFavouriteProductsForUser(id: id))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { productData -> Single<BackendData<Product>> in
                let task = ParseNetworkDataTask<Product>()
                return task.execute(withInput: productData)
            }
            .asObservable()
            .flatMap { data -> Observable<Product> in
                return Observable.from(data.data)
            }
            .toArray()
            .map { products -> Event in
                Event.gotFavourites(products: products, error: nil)
            }
            .catchErrorJustReturn(Event.gotFavourites(products: [], error: BoxitError.NoInternet))
            .startWith(Event.loadingFavouritesData)
    }
    
    static func save(favouriteProduct productId: String, forUserId id: String) -> Observable<Event> {
        let request = NetworkRequest(withOperation: NetworkOperation.saveProduct(id: id, asin: productId))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .asObservable()
            .map { result in return Event.commitSavingProduct }
            .catchErrorJustReturn(Event.revertSavingProduct(asin: productId))
            .startWith(Event.startSavingProduct(asin: productId))
    }
    
    static func delete(favouriteProduct productId: String, forUserId id: String) -> Observable<Event> {
        let request = NetworkRequest(withOperation: NetworkOperation.deleteProduct(id: id, asin: productId))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .asObservable()
            .map { result in return Event.commitDeletingProduct }
            .catchErrorJustReturn(Event.revertDeletingProduct(asin: productId))
            .startWith(Event.startDeletingProduct(asin: productId))
    }
    
    static func openAmazonUrlAsSideEffect(forProduct product: Product) -> Observable<Event> {
        //
        // get store
        let del = UIApplication.shared.delegate as! AppDelegate
        let store = del.store!
        
        //
        // open product
        if let url = product.clickUrl {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        //
        // get current user
        let ownId = store.current.loginState.ownId ?? ""
        let user = store.current.selectedUserState.user
        
        //
        // prep data
        let data = [
            "user_id": ownId,
            "friend_id": user?.id ?? "",
            "friend_name": user?.name ?? "",
            "product_id": product.asin,
            "product_name": product.title
        ]
        
        //
        // send analytics
        Analytics.logEvent("view_product", parameters: data)
        
        return Observable.just(Event.sideEffect)
    }
}

