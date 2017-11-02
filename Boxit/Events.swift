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

enum Event{
    case loadingLoginData
    case checkedLoginState(token: String?, ownId: String?, error: BoxitError?)
    case gotUser(forUserId: String, user: FacebookProfile?, error: BoxitError?)
    case loadingFriendsData
    case gotFriends(friends: [FacebookProfile], offset: String?, error: BoxitError?)
    case selectUser(user: FacebookProfile?)
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
}

