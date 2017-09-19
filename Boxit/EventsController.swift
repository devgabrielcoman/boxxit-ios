//
//  EventsController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxTableAndCollectionView
import Kingfisher
import FBSDKShareKit

extension State {
    enum Events {
        case initial
        case success(withViewModels: [Any])
        case error(withViewModel: ViewModels.DataLoadError)
        case empty
    }
}

//
// MARK: Base
class EventsController: BaseController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var eventsCollection: UICollectionView!
    
    var rxCollectionView: RxCollectionView?
    
    var facebookUser: String = "me"
    
    fileprivate var selectedId: String = "me"
    
    fileprivate var data: [FacebookProfile] = []
    fileprivate var offset: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setState(state: State.Events.initial)
        self.getEvents()
    }
}

//
// MARK: Business Logic
extension EventsController: BusinessLogic, FBSDKAppInviteDialogDelegate {
    
    func getEvents () {
        
        UserWorker.get(eventsForUserId: facebookUser, andOffset: offset)
            .asObservable()
            .do(onNext: { fbData in
                self.offset = fbData.offsetAfter
            })
            .flatMap { fbData -> Observable<[FacebookProfile]> in
                return Observable.just(fbData.data)
            }
            .catchErrorAndContinue { error in
                let vm = ViewModels.DataLoadError(hasRetry: true, errorText: "Events Error".localized)
                self.setState(state: State.Events.error(withViewModel: vm))
            }
            .subscribeNext { profiles in
                
                // update data
                self.data += profiles
                
                // no friends state
                if self.data.count == 0 {
                    self.setState(state: State.Events.empty)
                }
                // success state
                else {
                    
                    // get users
                    var viewModels: [Any] = self.data.map { profile -> ViewModels.User in
                        return ViewModels.User(profile: profile)
                    }
                    
                    // now add the invite cell
                    viewModels += [ViewModels.Invite()]
                    
                    //
                    // and set the state as success with appropiate view models
                    self.setState(state: State.Events.success(withViewModels: viewModels))
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func select(user: FacebookProfile) {
        
        // select a user
        selectedId = user.id
        
        // perform the segue
        self.performSegue(.EventsToUser)
        
    }
    
    func inviteAction() {
        
        let request = InviteRequest()
        let content = FBSDKAppInviteContent()
        content.appLinkURL = request.inviteUrl
        content.appInvitePreviewImageURL = request.previewUrl
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Results are \(results)")
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Complete with error \(error)")
    }
}

//
// MARK: State Logic
extension EventsController: StateLogic {
    
    func setState(state: State.Events) {
        switch state {
        //
        // initial case
        case .initial:
            
            let size = UIScreen.main.bounds.size.width / 2
            
            rxCollectionView = RxCollectionView.create()
                .bind(toCollection: eventsCollection)
                .set(sizeForCellWithReuseIdentifier: InviteCell.Identifier) { (index, model: ViewModels.User) -> CGSize in
                    return CGSize(width: size, height: 200)
                }
                .set(sizeForCellWithReuseIdentifier: EventsCell.Identifier) { (index, model: ViewModels.Invite) -> CGSize in
                    return CGSize(width: size, height: 200)
                }
                .customise(cellForReuseIdentifier: EventsCell.Identifier) { (index, cell: EventsCell, model: ViewModels.User, total) in
                    
                    cell.rightSeparator.isHidden = index.row % 2 != 0
                    cell.profilePicture.kf.setImage(with: model.profile.pictureUrl)
                    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
                    cell.profilePicture.kf.indicatorType = .activity
                    cell.profileName.text = model.profile.name
                    cell.profileBirthday.text = model.birthdayShort
                    
                    print("BDAY: \(model.profile.birthday)\t\t\(model.profile.nextBirthday)")
                    
                }
                .customise(cellForReuseIdentifier: InviteCell.Identifier) { (index, cell: InviteCell, model: ViewModels.Invite, total) in
                    
                    cell.rightSeparator.isHidden = index.row % 2 != 0
                    cell.inviteLabel.text = "Invite Button".localized
                    cell.inviteLabel.layer.cornerRadius = 15
                    cell.inviteIcon.layer.cornerRadius = 35
                    
                }
                .did(clickOnCellWithReuseIdentifier: EventsCell.Identifier) { (index, model: ViewModels.User) in
                    self.select(user: model.profile)
                }
                .did(clickOnCellWithReuseIdentifier: InviteCell.Identifier) { (index, model: ViewModels.Invite) in
                    self.inviteAction()
                }
                .did(reachEnd: {
                    if self.offset != nil {
                        self.getEvents()
                    }
                })
            
            break
        //
        // success
        case .success(let viewModels):
            
            spinner.stopAnimating()
            
            rxCollectionView?.update(withData: viewModels)
            break
        //
        // empty case 
        case .empty:
            
            spinner.stopAnimating()
            
            let controller: ErrorController? = self.getChild()
            controller?.setState(state: State.Error.visible(withErrorMessage: "Events Invite Text".localized, andHasRetryButton: true, andRetryButtonText: "Invite Button".localized))
            controller?.didClickOnRetry = {
                self.inviteAction()
            }
            
            break
        //
        // error case
        case .error(let viewModel):
            
            spinner.stopAnimating()
            
            let controller: ErrorController? = self.getChild()
            controller?.setState(state: State.Error.visible(withErrorMessage: viewModel.errorText, andHasRetryButton: viewModel.hasRetry, andRetryButtonText: nil))
            controller?.didClickOnRetry = {
                controller?.setState(state: State.Error.hidden)
                self.spinner.startAnimating()
                self.getEvents()
            }
            
            break
        }
    }
    
}

//
// MARK: Routing Logic
extension EventsController: EventsRoutingLogic {
    
    func prepare(controller: UserController) {
        controller.facebookUser = selectedId
    }
}
