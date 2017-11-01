//
//  Workers+UserProfile.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

//
// MARK: Get Profile
extension UserWorker {
    
    static func get(profileForUserId id: String) -> Single<FacebookProfile> {
        
        if let user = DataStore.shared.get(userForId: id) {
            return Single.just(user)
        }
        
        let request = NetworkRequest(withOperation: NetworkOperation.getProfileFromFacebook(forUser: id))
        let task = NetworkTask()
        return task.execute(withInput: request)
            .flatMap { fbData -> Single<FacebookProfile> in
                let task = ParseFacebookProfileTask()
                return task.execute(withInput: fbData)
            }
            .do(onNext: { profile in
                DataStore.shared.save(user: profile, forId: id)
            })
    }
}

////
//// Send Profile data main function
//extension UserWorker {
//
//    static func populateUserProfile(forToken token: String) -> Single<Void> {
//        let request = NetworkRequest(withOperation: NetworkOperation.populateUserProfile(token: token))
//        let task = NetworkTask()
//        return task.execute(withInput: request).map { value -> Void in return () }
//    }
//}

//
// MARK: Update Token
extension UserWorker {
    
    static func update(notificationToken token: String?, forUserId id: String) -> Single<Void> {
        let request = NetworkRequest(withOperation: NetworkOperation.saveNotificationToken(id: id, token: token))
        let task = NetworkTask()
        return task.execute(withInput: request).map{ result in return () }
    }
}

//
// Get friends - from facebook
extension UserWorker {
    
    static func get(eventsForUserId id: String, andOffset offset: String?) -> Single<FacebookData<FacebookProfile>> {
        
        let request = NetworkRequest(withOperation: NetworkOperation.getFriendsFromFacebook(forUser: id, offset: offset))
        let task = NetworkTask ()
        return task.execute(withInput: request)
            .flatMap { friendData -> Single<FacebookData<FacebookProfile>> in
                
                let task = ParseFacebookDataTask<FacebookProfile>()
                return task.execute(withInput: friendData)
        }
    }
}

////
//// MARK: Invite
//extension UserWorker {
//    
//    static func inviteUsers(fromViewController controller: UIViewController) -> Observable<Void> {
//        let request = InviteRequest(withViewController: controller)
//        let task = InviteTask()
//        return task.execute(withInput: request)
//    }
//}
