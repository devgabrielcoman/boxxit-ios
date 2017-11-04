//
//  WelcomeTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher


class TutorialWelcomeController: BaseController {

    @IBOutlet weak var continueText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueText.text = "Start Text".localized
        
        let user = store.current.currentUserState.currentUser
        if let profile = user, let firstName = profile.firstName {
            mainText.text = String(format: "Tutorial Welcome Text ".localized, firstName)
            profilePicture.kf.setImage(with: profile.pictureUrl)
        }
    }
}
