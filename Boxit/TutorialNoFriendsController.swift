//
//  TutorialNoFriendsController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension State {
    enum TutorialNoFriends {
        case initial
    }
}

//
// MARK: Base
class TutorialNoFriendsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var exploreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialNoFriends.initial)
    }
}

//
// MARK: Business Logic
extension TutorialNoFriendsController: BusinessLogic {
    
    @IBAction func exploreAction(_ sender: Any) {
        TutorialDriver.shared.drivenAction?()
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        
        UserWorker.inviteUsers(fromViewController: self)
            .catchErrorAndContinue { error in
                // do nothing
            }
            .subscribeNext {
                // do nothing
            }
            .addDisposableTo(disposeBag)
    }
}

//
// MARK: State
extension TutorialNoFriendsController: StateLogic {
    
    func setState(state: State.TutorialNoFriends) {
        switch state {
            //
        // initial state
        case .initial:
            
            //
            // set state
            tutorialText.text = "Tutorial No Friends Text".localized
            exploreButton.setTitle("No Friends Action".localized, for: .normal)
            
            break
        }
    }
}
