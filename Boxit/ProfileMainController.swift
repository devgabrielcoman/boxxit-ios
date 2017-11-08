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

    @IBOutlet weak var profilePicture: UIImageView?
    @IBOutlet weak var profileName: UILabel?
    @IBOutlet weak var profileBirthday: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = store.current.currentUserState.currentUser
        if let user = user {
            let viewModel = ViewModels.User(profile: user)
            profilePicture?.kf.setImage(with: viewModel.profile.pictureUrl)
            profileName?.text = viewModel.profile.name
            profileBirthday?.text = viewModel.birthdayShort
        }
    }
    
    @IBAction func gotoUserController(_ sender: Any) {
       let current = store.current.currentUserState.currentUser
        performSegue(AppSegues.ProfileMainToUser)
        store.dispatch(Event.selectUser(user: current))
    }
}


