//
//  ProfileMainController.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ProfileMainController: BaseController {

    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var profilePicture: UIImageView?
    @IBOutlet weak var profileName: UILabel?
    @IBOutlet weak var profileBirthday: UILabel?
    @IBOutlet weak var favouriteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = store.current.selectedUserState.user ?? store.current.currentUserState.currentUser
        let viewModel = ViewModels.User(profile: user!)
        profilePicture?.kf.setImage(with: viewModel.profile.pictureUrl)
        profileName?.text = viewModel.profile.name
        profileBirthday?.text = viewModel.birthdayShort
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        //
        // go back
        self.navigationController?.popViewController(animated: true)
        
        //
        // if has tutorial make sure to show it
        let hasTutorial = store.current.tutorialState.hasTutorial
        if hasTutorial {
            store.dispatch(Event.advanceTutorial)
        }
    }
    
    @IBAction func gotoUserController(_ sender: Any) {
       let current = store.current.currentUserState.currentUser
       store.dispatch(Event.selectUser(user: current))
       performSegue(AppSegues.ProfileMainToUser)
    }
}


