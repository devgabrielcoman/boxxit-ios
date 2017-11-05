//
//  WelcomeTutorialController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications
import Firebase

class TutorialController: BaseController {

    @IBOutlet weak var continueText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    
    weak var application: UIApplication? = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // set store
        store.addListener(self)
        store.dispatch(Event.advanceTutorial)
        
        //
        // set app delegate for notifications
        (application?.delegate as? AppDelegate)?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // do nothing
    }
    
    @IBAction func onTap(_ sender: Any) {
        let step = store.current.tutorialState.currentStep
        if step == .Step3 {
            tryToEnableNotifications()
        } else {
            store.dispatch(Event.advanceTutorial)
        }
    }
    
    override func handle(_ state: AppState) {
        let step = store.current.tutorialState.currentStep
        switch step {
        case .Initial:
            // do nothing
            break
        case .Step1:
            //
            // set text & style
            continueText.text = "Tutorial - Continue Text".localized
            infoText.text = "Tutorial - Step 1".localized
            
            let user = store.current.currentUserState.currentUser
            if let profile = user, let firstName = profile.firstName {
                mainText.text = String(format: "Tutorial - Welcome Text".localized, firstName)
                profilePicture.kf.setImage(with: profile.pictureUrl)
            }
            break
        case .Step2:
            infoText.text = "Tutorial - Step 2".localized
            break
        case .Step3:
            infoText.text = "Tutorial - Step 3".localized
            continueText.text = "Tutorial - Start Text".localized
            break
        case .Done:
            self.view.isHidden = true
            break
        }
    }
}

extension TutorialController: EnableNotificationResponder {
    
    func tryToEnableNotifications () {
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
