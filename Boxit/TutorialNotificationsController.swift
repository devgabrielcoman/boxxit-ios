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

class TutorialNotificationsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var skipText: UILabel!
    @IBOutlet weak var enableNotifButton: UIButton!
    
    weak var application: UIApplication? = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // set app delegate for notifications
        (application?.delegate as? AppDelegate)?.delegate = self
        
        //
        // set style
        enableNotifButton.loginStyle()
        skipText.text = "Skip Text".localized
        enableNotifButton.setTitle("Enable Notifications".localized, for: .normal)
        tutorialText.text = "Tutorial Notifications Text".localized
    }
}

extension TutorialNotificationsController: EnableNotificationResponder {
    
    @IBAction func enableAction(sender: Any) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { result, error in
                DispatchQueue.main.async {
                    self.didTapOnNotificationAlert()
                }
            }
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.application?.registerUserNotificationSettings(settings)
        }
    }
    
    func didTapOnNotificationAlert() {
        store.dispatch(Event.advanceTutorial)
    }
}
