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

class LoadController: BaseController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadUser()
    }
    
    private func loadUser () {
        if let userId = store.current.loginState.ownId {
            store.dispatch(Event.get(profileForUserId: userId))
        }
    }
    
    override func handle(_ state: AppState) {
        let currentUserState = state.currentUserState
        
        //
        // error case
        if currentUserState.error != nil {
            
            Alertift.alert(title: "Network Error Title".localized, message: "Network Error Message".localized)
                .action(.cancel("Alert Cancel".localized))
                .action(.default("Alert Try Again".localized), isPreferred: true, handler: {
                    self.loadUser()
                })
                .show()
        }
        
        //
        // success case
        if let _ = currentUserState.currentUser {
            performSegue(AppSegues.LoadToMain)
        }
    }
}

