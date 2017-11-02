//
//  UserController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

//
// MARK: Base
class UserController: BaseController {

    var facebookUser: String = "me"
    var hasInfoButton: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // do this just once
        TutorialDriver.shared.setState(state: State.Tutorial.explore)
    }
}

////
//// MARK: Routing Logic
//extension UserController: UserRoutingLogic {
//    
//    func embed(controller1: ProfileHeaderController) {
//        controller1.hasInfoButton = hasInfoButton
//        controller1.facebookUser = facebookUser
//    }
//    
//    func embed(controller2: ExploreController) {
//        controller2.facebookUser = facebookUser
//    }
//}

