//
//  FriendsTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension State {
    enum TutorialFriends {
        case initial
    }
}

//
// MARK: Base
class TutorialFriendsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var continueText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialFriends.initial)
    }
}

//
// MARK: State
extension TutorialFriendsController: StateLogic {
    
    func setState(state: State.TutorialFriends) {
        switch state {
            //
        // initial state
        case .initial:
            
            //
            // set texts
            continueText.text = "Friend Tap Text".localized
            tutorialText.text = "Tutorial Friends Text".localized
            
            break
        }
    }
}
