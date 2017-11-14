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

class EventsController: BaseController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var eventsCollection: UICollectionView!
    @IBOutlet weak var errorControllerView: UIView!
    @IBOutlet weak var inviteControllerView: UIView!
    @IBOutlet weak var yourFriendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // do some setup
        let controller: ErrorController? = self.getChild()
        controller?.textLabel.text = "Events Error".localized
        controller?.didClickOnRetry = { self.reloadData() }
        
        //
        // set store
        store.addListener(self)
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // do nothing
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // do nothing
    }
    
    func reloadData () {
        let ownId = store.current.loginState.ownId
        let offset = store.current.friendsState.offset
        store.dispatch(Event.get(friendsForUserId: ownId, withOffset: offset))
    }
    
    override func handle(_ state: AppState) {
        let friendsState = state.friendsState
        eventsCollection.reloadData()
        spinner.isHidden = !friendsState.isLoading
        inviteControllerView.isHidden = friendsState.isLoading || friendsState.friends.count > 0 || friendsState.error != nil
        errorControllerView.isHidden = friendsState.error == nil
    }
    
    deinit {
        store.removeListener(self)
    }
}

extension EventsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.current.friendsState.friends.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventsCell.Identifier, for: indexPath) as! EventsCell
        let item = store.current.friendsState.friends[indexPath.row]
        cell.viewModel = ViewModels.User(profile: item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2.15
        let height = (UIScreen.main.bounds.size.height - 80) / 2 - 41
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = store.current.friendsState.friends[indexPath.row]
        store.dispatch(Event.selectUser(user: item))
        performSegue(AppSegues.EventsToUser)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.bounds.maxX >= scrollView.contentSize.width && store.current.friendsState.canStillAdd {
            reloadData()
        }
    }
}

