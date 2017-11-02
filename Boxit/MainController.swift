//
//  MainController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

//
// MARK: Base
class MainController: BaseController {

    @IBOutlet weak var inviteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("State is \(store.current)")
        
//        // set state
//        TutorialDriver.shared.setState(state: State.Tutorial.welcome)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if TutorialDriver.shared.shouldShowNotifications() {
//            TutorialDriver.shared.setState(state: State.Tutorial.notifications)
//        }
//    }
}

////
//// MARK: Routing Logic
//extension MainController: MainRoutingLogic {
//
//    func prepare(controller1: UserController) {
//        controller1.facebookUser = "me"
//    }
//
//    func embed(controller2: ProfileMainController) {
//        controller2.facebookUser = "me"
//    }
//
//    func embed(controller3: EventsController) {
//        controller3.facebookUser = "me"
//    }
//}

