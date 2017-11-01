//
//  LoadController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import Alertift

//extension State {
//    enum Load {
//        case error
//    }
//}

//
// MARK: Base
class LoadController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("State is \(store.current)")
//        self.loadUser()
    }
}

//// MARK: Business
//extension LoadController: BusinessLogic {
//
//    func loadUser() {
//
//        UserWorker.get(profileForUserId: "me")
//            .subscribe(onSuccess: { profile in
//                self.performSegue(AppSegues.LoadToMain)
//            }, onError: { error in
//                self.setState(state: .error)
//            })
//            .addDisposableTo(disposeBag)
//    }
//}

//// MARK: State Logic
//extension LoadController: StateLogic {
//    
//    func setState (state: State.Load) {
//        switch state {
//        //
//        // error state
//        case .error:
//            
//            Alertift.alert(title: "Network Error Title".localized, message: "Network Error Message".localized)
//                .action(.cancel("Alert Cancel".localized))
//                .action(.default("Alert Try Again".localized), isPreferred: true, handler: {
//                    self.loadUser()
//                })
//                .show()
//            
//            break
//        }
//    }
//}

