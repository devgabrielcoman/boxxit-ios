//
//  IntroController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class IntroController: BaseController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(Event.checkLoginState())
    }
    
    override func handle(_ state: AppState) {
        let loginState = state.loginState
        let isLoading = loginState.isLoading
        if isLoading { return }
        let segue = loginState.ownId != nil && loginState.token != nil ? AppSegues.IntroToLoad : AppSegues.IntroToLogin
        performSegue(segue)
    }
}
