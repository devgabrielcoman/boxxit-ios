//
//  ProfileHeaderController.swift
//  Boxxit
//
//  Created by Gabriel Coman on 08/11/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ProfileHeaderController: BaseController {
    
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var profilePicture: UIImageView?
    @IBOutlet weak var profileName: UILabel?
    @IBOutlet weak var profileBirthday: UILabel?
    @IBOutlet weak var favouriteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.addListener(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //
    }
    
    override func handle(_ state: AppState) {
        let selUserState = state.selectedUserState
        if let user = selUserState.user {
            let viewModel = ViewModels.User(profile: user)
            profilePicture?.kf.setImage(with: viewModel.profile.pictureUrl)
            profileName?.text = viewModel.profile.name
            profileBirthday?.text = viewModel.birthdayShort
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
