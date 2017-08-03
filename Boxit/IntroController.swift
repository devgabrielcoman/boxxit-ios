//
//  IntroController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

//
// MARK: Base
class IntroController: BaseController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLogin()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//
// MARK: Business
extension IntroController: BusinessLogic {
    
    func checkLogin() {
        UserWorker.isUserLoggedIn() ? performSegue(.IntroToLoad) : performSegue(.IntroToLogin)
    }
}
