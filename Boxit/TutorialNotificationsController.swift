//
//  NotificationsController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import RxSwift

extension State {
    enum TutorialNotification {
        case initial
    }
}

//
// MARK: Base
class TutorialNotificationsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var skipText: UILabel!
    @IBOutlet weak var enableNotifButton: UIButton!
    
    weak var application: UIApplication? = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.TutorialNotification.initial)
    }
}

//
// MARK: Business Logic
extension TutorialNotificationsController: BusinessLogic, EnableNotificationResponder {
    
    @IBAction func enableAction(sender: Any) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { result, error in
                self.didTapOnNotificationAlert()
            }
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.application?.registerUserNotificationSettings(settings)
        }
    }
    
    func didTapOnNotificationAlert() {
        TutorialDriver.shared.setState(state: State.Tutorial.hidden)
    }
}

//
// MARK: State Logic
extension TutorialNotificationsController: StateLogic {
    
    func setState(state: State.TutorialNotification) {
        switch state {
        case .initial:
            //
            // set style
            enableNotifButton.loginStyle()
            
            //
            // set delegate
            (application?.delegate as? AppDelegate)?.delegate = self
            
            //
            // set text
            skipText.text = "Skip Text".localized
            enableNotifButton.setTitle("Enable Notifications".localized, for: .normal)
            tutorialText.text = "Tutorial Notifications Text".localized
            break
        }
    }
}
