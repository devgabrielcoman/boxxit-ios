//
//  TutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 25/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

//extension State {
//    enum Tutorial {
//        case start
//        case welcome
//        case yourProfile
//        case yourFriends
//        case noFriends
//        case explore
//        case notifications
//        case hidden
//    }
//}

//
// MARK: Base
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

////
//// MARK: Business Logic
//extension TutorialMainController: BusinessLogic {
//
//
//}
//
////
//// MARK: State
//extension TutorialMainController: StateLogic {
//
//    func setState(state: State.Tutorial) {
//
//        self.view.isHidden = false
//        welcomeContainer.isHidden = true
//        yourProfileContainer.isHidden = true
//        yourFriendsContainer.isHidden = true
//        noFriendsContainer.isHidden = true
//        exploreContainer.isHidden = true
//        notificationContainer.isHidden = true
//
//        tapEnabled = true
//
//        let screen = UIScreen.main.bounds
//        self.view.frame = screen
//
//        switch state {
//        case .start:
//            break
//        case .welcome:
//            welcomeContainer.isHidden = false
//            break
//        case .yourProfile:
//            yourProfileContainer.isHidden = false
//            break
//        case .yourFriends:
//            tapEnabled = false
//            self.view.frame = CGRect(x: 0, y: 0, width: screen.size.width, height: 270)
//            yourFriendsContainer.isHidden = false
//            break
//        case .noFriends:
//            tapEnabled = false
//            noFriendsContainer.isHidden = false
//            break
//        case .explore:
//            exploreContainer.isHidden = false
//            break
//        case .notifications:
//            notificationContainer.isHidden = false
//            break
//        case .hidden:
//            self.view.isHidden = true
//            break
//        }
//    }
//}
//
////
//// the tutorial Driver
//class TutorialDriver {
//
//    static let shared = TutorialDriver()
//
//    var state: State.Tutorial = .start
//
//    var drivenAction: ((Void) -> Void)?
//
//    var controller: TutorialMainController?
//
//    var stateHandler: [State.Tutorial: Bool] = [
//        .start: false,
//        .welcome: false,
//        .yourProfile: false,
//        .yourFriends: false,
//        .noFriends: false,
//        .explore: false,
//        .notifications: false,
//        .hidden: false
//    ]
//
//    func shouldShowNotifications () -> Bool {
//        if let st = stateHandler[.explore], st {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func setState(state: State.Tutorial) {
//
//        if let st = stateHandler[state], !st {
//            //
//            // update new state
//            self.state = state
//
//            //
//            // update state handler
//            stateHandler[state] = true
//        } else {
//            //
//            // set state to hidden
//            self.state = .hidden
//        }
//
//        //
//        // send it to the controller
//        controller?.setState(state: self.state)
//    }
//
//    func advanceState () {
//
//        switch state {
//        case .welcome:
//            setState(state: .yourProfile)
//            break
//        case .yourProfile:
//            //
//            // get current profile
//            let profile = DataStore.shared.get(userForId: "me")
//
//            //
//            // if has friends, fine, if not, not!
//            if let profile = profile, profile.friends.count > 0 {
//                setState(state: .yourFriends)
//            } else {
//                setState(state: .noFriends)
//            }
//            break
//        case .yourFriends, .noFriends, .explore, .notifications:
//            setState(state: .hidden)
//            break
//        case .hidden, .start:
//            break
//        }
//    }
//}

