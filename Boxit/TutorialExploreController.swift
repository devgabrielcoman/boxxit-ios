//
//  ExploreTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension State {
    enum TutorialExplore {
        case initial
    }
}

//
// MARK: Base
class TutorialExploreController: UIViewController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var continueText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialExplore.initial)
   }
}

//
// MARK: State
extension TutorialExploreController: StateLogic {
    
    func setState(state: State.TutorialExplore) {
        switch state {
            //
        // initial state
        case .initial:
            
            //
            // set texts
            continueText.text = "Continue Text".localized
            tutorialText.text = "Tutorial Explore Text".localized
            
            break
        }
    }
}
