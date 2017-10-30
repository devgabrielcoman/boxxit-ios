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
    case checkedLoginState(token: String?, ownId: String?)
    case logedUserIn(token: String?, error: BoxitError?)
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
            .just(Event.checkedLoginState(token: accessToken, ownId: ownId))
            .startWith(Event.loadingLoginData)
    }
    
    static func loginUser (fromViewController controller: UIViewController) -> Observable<Event> {
        
        let request = FacebookAuthRequest(withViewController: controller)
        let task = FacebookAuthTask()
        return task.execute(withInput: request)
            .asObservable()
            .map { token -> Event in
                return Event.logedUserIn(token: token, error: nil)
            }
            .catchError { error -> Observable<Event> in
                switch error {
                case BoxitError.FbAuthCancelled:
                    return Observable.just(Event.logedUserIn(token: nil, error: nil))
                default:
                    return Observable.just(Event.logedUserIn(token: nil, error: BoxitError.FbAuthError))
                }
            }
            .startWith(Event.loadingLoginData)
    }
}

