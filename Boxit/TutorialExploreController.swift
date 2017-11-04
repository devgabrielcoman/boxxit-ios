//
//  ExploreTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class TutorialExploreController: UIViewController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var continueText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueText.text = "Continue Text".localized
        tutorialText.text = "Tutorial Explore Text".localized
   }
}
