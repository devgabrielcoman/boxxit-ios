//
//  ProfileHeaderController.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

extension State {
    enum ProfileHeader {
        case initial
        case success(withViewModel: ViewModels.User)
    }
}

//
// MARK: Base
class ProfileHeaderController: BaseController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBirthday: UILabel!

    @IBOutlet weak var favouriteButton: UIButton!
    
    var hasInfoButton: Bool = true
    var facebookUser: String = "me"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setState(state: State.ProfileHeader.initial)
        getUserProfile(forUser: facebookUser)
    }
}

//
// MARK: Business Logic
extension ProfileHeaderController: BusinessLogic {
    
    func getUserProfile(forUser id: String) {
        
        UserWorker.get(profileForUserId: id)
            .subscribe(onSuccess: { profile in
                
                let vm = ViewModels.User(profile: profile)
                self.setState(state: State.ProfileHeader.success(withViewModel: vm))
                
            }, onError: { error in
                // do nothing for now
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//
// MARK: State Logic
extension ProfileHeaderController: StateLogic {
    
    func setState(state: State.ProfileHeader) {
        switch state {
        //
        // view in initial state
        case .initial:
    
            favouriteButton.isHidden = !hasInfoButton
            break
        //
        // view in sucess / loaded state
        case .success(let viewModel):
            
            profilePicture.kf.setImage(with: viewModel.profile.pictureUrl)
            profileName.text = viewModel.profile.name
            profileBirthday.text = viewModel.birthdayShort
            break
        }
    }
    
}

//
// MARK: Routing Logic
extension ProfileHeaderController: ProfileHeaderRoutingLogic {
    
    func prepare(controller: FavouriteController) {
        controller.facebookUser = facebookUser
    }
}
