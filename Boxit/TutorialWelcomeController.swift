//
//  WelcomeTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher

extension State {
    enum TutorialWecome {
        case initial
    }
}

//
// MARK: Base
class TutorialWelcomeController: BaseController {

    @IBOutlet weak var continueText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialWecome.initial)
    }
}

//
// MARK: State Logic
extension TutorialWelcomeController: StateLogic {
    
    func setState (state: State.TutorialWecome) {
        switch state {
        //
        // initital state
        case .initial:
            
            //
            // set profile dependent text
            let profile = DataStore.shared.get(userForId: "me")
            
            if let profile = profile, let firstName = profile.firstName {
                mainText.text = String(format: "Tutorial Welcome Text ".localized, firstName)
                profilePicture.kf.setImage(with: profile.pictureUrl)
            }
            
            //
            // set continue text
            continueText.text = "Start Text".localized
            
            break
        }
    }
}
