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
    // login
    case loadingLoginData
    case checkedLoginState(token: String?, ownId: String?, error: BoxitError?)
    case gotUser(forUserId: String, user: FacebookProfile?, error: BoxitError?)
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
}

