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

//extension State {
//    enum ProfileMain {
//        case initital
//        case success(withViewModel: ViewModels.User)
//    }
//}

//
// MARK: Base
class ProfileMainController: BaseController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBirthday: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
//    var facebookUser: String = "me"
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //
//        // set initial state
//        setState(state: State.ProfileMain.initital)
//
//        //
//        // get user profile
//        getUserProfile()
//
//        //
//        // @hack!!!
//        // link to tutorial
//        linkToTutorialDrivenAction()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = store.current.selectedUser ?? store.current.currentUserState.currentUser
        let viewModel = ViewModels.User(profile: user!)
        profilePicture.kf.setImage(with: viewModel.profile.pictureUrl)
        profileName.text = viewModel.profile.name
        profileBirthday.text = viewModel.birthdayShort
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func handle(_ state: AppState) {
        
    }
}

////
//// MARK: Business Logic
//extension ProfileMainController: BusinessLogic {
//
//    func linkToTutorialDrivenAction () {
//        TutorialDriver.shared.drivenAction = {
//            self.performSegue(AppSegues.MainHeaderToUser)
//        }
//    }
//
//    func getUserProfile() {
//
//        UserWorker.get(profileForUserId: "me")
//            .subscribe(onSuccess: { profile in
//
//                let vm = ViewModels.User(profile: profile)
//                self.setState(state: State.ProfileMain.success(withViewModel: vm))
//
//            }, onError: { error in
//                // do nothing for now
//            })
//            .addDisposableTo(disposeBag)
//    }
//}
//
////
//// MARK: State Logic
//extension ProfileMainController: StateLogic {
//
//    func setState(state: State.ProfileMain) {
//        switch state {
//        case .initital:
//            // do nothing
//            break
//        case .success(let viewModel):
//
//            profilePicture.kf.setImage(with: viewModel.profile.pictureUrl)
//            profileName.text = viewModel.profile.name
//            profileBirthday.text = viewModel.birthdayShort
//
//            break
//        }
//    }
//}

