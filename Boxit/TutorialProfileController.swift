//
//  ProfileTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension State {
    enum TutorialProfile {
        case initial
    }
}

//
// MARK: Base
class TutorialProfileController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var continueText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialProfile.initial)
    }
}

//
// MARK: State
extension TutorialProfileController: StateLogic {
    
    func setState(state: State.TutorialProfile) {
        switch state {
        //
        // initial state
        case .initial:
            
            //
            // set texts
            continueText.text = "Continue Text".localized
            tutorialText.text = "Tutorial Profile Text".localized
            
            break
        }
    }
    
}
