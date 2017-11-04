//
//  LoginController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alertift

class LoginController: BaseController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.loginStyle()
        loginButton.setTitle("Login Button Title".localized, for: .normal)
    }
    
    @IBAction func loginAction(sender: Any) {
        store.dispatch(Event.loginUser(fromViewController: self))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        store.dispatch(Event.showTutorial)
    }
    
    override func handle(_ state: AppState) {
        let loginState = state.loginState
        
        loginButton.isHidden = loginState.isLoading
        spinner.isHidden = !loginState.isLoading
        
        //
        // in case of error
        if loginState.error != nil {
            Alertift.alert(title: "Auth Error Title".localized, message: "Auth Error Message".localized)
                .action(.default("Alert OK".localized))
                .show()
        }
        
        //
        // login success
        if loginState.token != nil {
            
            //
            // goto load page
            performSegue(.LoginToLoad)
        
            //
            // remove listener
            store.removeListener(self)
        }
    }
}

