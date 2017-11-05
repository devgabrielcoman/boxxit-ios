//
//  TutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 25/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class TutorialMainController: BaseController {

    @IBOutlet weak var welcomeContainer: UIView!
    @IBOutlet weak var yourProfileContainer: UIView!
    @IBOutlet weak var yourFriendsContainer: UIView!
    @IBOutlet weak var noFriendsContainer: UIView!
    @IBOutlet weak var exploreContainer: UIView!
    @IBOutlet weak var notificationContainer: UIView!
    
    fileprivate var tapEnabled = true
    
    @IBAction func onTap(_ sender: Any) {
        if tapEnabled {
            store.dispatch(Event.advanceTutorial)
        }
    }
    
    override func handle(_ state: AppState) {

        self.view.isHidden = false
        welcomeContainer.isHidden = true
        yourProfileContainer.isHidden = true
        yourFriendsContainer.isHidden = true
        noFriendsContainer.isHidden = true
        exploreContainer.isHidden = true
        notificationContainer.isHidden = true

        let screen = UIScreen.main.bounds
        self.view.frame = screen
        
        tapEnabled = true
        
        switch state.tutorialState.currentStep {
        case .Welcome:
            welcomeContainer.isHidden = false
            break
        case .You:
            yourProfileContainer.isHidden = false
            break
        case .Friends:
            tapEnabled = false
            self.view.frame = CGRect(x: 0, y: 0, width: screen.size.width, height: 270)
            yourFriendsContainer.isHidden = false
            break
        case .NoFriends:
            tapEnabled = false
            noFriendsContainer.isHidden = false
            break
        case .Explore:
            exploreContainer.isHidden = false
            break
        case .Explore2:
            self.view.isHidden = true
            break
        case .Final:
            notificationContainer.isHidden = false
            break
        case .Done:
            self.view.isHidden = true
            break
        }
    }
}
