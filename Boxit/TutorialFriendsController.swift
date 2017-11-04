//
//  FriendsTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class TutorialFriendsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var continueText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueText.text = "Friend Tap Text".localized
        tutorialText.text = "Tutorial Friends Text".localized
    }
}
