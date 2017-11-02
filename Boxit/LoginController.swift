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
    
    fileprivate var vc: TutorialMainController!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.loginStyle()
        loginButton.setTitle("Login Button Title".localized, for: .normal)
    }
    
    @IBAction func loginAction(sender: Any) {
        store.dispatch(Event.loginUser(fromViewController: self))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // do nothing
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
            performSegue(.LoginToLoad)
            store.removeListener(self)
        }
    }
}

//// MARK: Business
//extension LoginController: BusinessLogic {
//
//    @IBAction func loginAction(sender: Any) {
//
////        UserWorker.login(withFacebookFromViewController: self)
////            .do(onSubscribed: {
////                self.setState(state: State.Login.loading)
////            })
////            .flatMap { token -> Single<Void> in
////                return UserWorker.populateUserProfile(forToken: token)
////            }
////            .flatMap { () -> Single<FacebookProfile> in
////                return UserWorker.get(profileForUserId: "me")
////            }
////            .subscribe(onSuccess: { profile in
////
////                //
////                // perform segue
////                self.performSegue(.LoginToMain)
////
////                //
////                // set tutorial state from this controller
////                self.setState(state: State.Login.tutorial)
////
////            }, onError: { error in
////
////                print("Error is \(error)")
////
////                // end loading state
////                self.setState(state: State.Login.notLoading)
////
////                switch error {
////                // do nothing here
////                case BoxitError.FbAuthCancelled:
////                    break
////                // or set the state to major error
////                default:
////                    self.setState(state: State.Login.error)
////                    break
////                }
////            })
////            .addDisposableTo(disposeBag)
//    }
//}

//// MARK: State Logic
//extension LoginController: StateLogic {
//
//    func setState(state: State.Login) {
//        switch state {
//        //
//        // initial controller state
//        case .initial:
//            loginButton.loginStyle()
//            loginButton.setTitle("Login Button Title".localized, for: .normal)
//            break
//        //
//        // loading state
//        case .loading:
//            loginButton.isHidden = true
//            spinner.isHidden = false
//            spinner.startAnimating()
//            break
//        //
//        // not-loading state
//        case .notLoading:
//            self.loginButton.isHidden = false
//            self.spinner.stopAnimating()
//            break
//        //
//        // error state
//        case .error:
//            Alertift.alert(title: "Auth Error Title".localized, message: "Auth Error Message".localized)
//                .action(.default("Alert OK".localized))
//                .show()
//            break
//        //
//        // tutorial state
//        case .tutorial:
//            //
//            // create view controller for tutorial
//            if self.vc == nil {
//                let screen = UIScreen.main.bounds.size
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                self.vc = storyboard.instantiateViewController(withIdentifier: "TutorialMainControllerID") as! TutorialMainController
//                let window = UIApplication.shared.keyWindow
//                self.vc.view.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
//                window?.addSubview(self.vc.view)
//            }
//
//            //
//            // set the controller for the state
//            TutorialDriver.shared.controller = self.vc
//            break
//        }
//    }
//}

