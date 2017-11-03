//
//  FavouriteController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxTableAndCollectionView
import Kingfisher

class FavouriteController: BaseController {

    @IBOutlet weak var favouritesTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var noFavLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // some setup
        let header: ProfileMainController? = getChild()
        header?.favouriteButton?.isHidden = true
        
        noFavLabel.text = "Favourites No Fav".localized
        
        let error: ErrorController? = getChild()
        error?.textLabel.text = "Favourites Error".localized
        error?.didClickOnRetry = { self.loadFavourites() }
        
        //
        // add listener
        store.addListener(self)
        
        //
        // load data
        self.loadFavourites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // do nothing
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // do nothing
    }
    
    private func loadFavourites () {
        if let userId = store.current.selectedUserState.user?.id {
            store.dispatch(Event.get(favouriteProductsForUserId: userId))
        }
    }
    
    override func handle(_ state: AppState) {
        let favouritesState = state.favouritesState
        favouritesTable.isHidden = favouritesState.isLoading
        spinner.isHidden = !favouritesState.isLoading
        errorContainer.isHidden = favouritesState.error == nil
        favouritesTable.reloadData()
        noFavLabel.isHidden = favouritesState.isLoading || favouritesState.favourites.count > 0 || favouritesState.error != nil
    }
    
    deinit {
        store.removeListener(self)
    }
}

extension FavouriteController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.current.favouritesState.favourites.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.transparentView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.transparentView()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: FavouriteRow.Identifier, for: indexPath) as! FavouriteRow
        row.viewModel = store.current.favouritesState.favourites[indexPath.row]
        return row
    }
}
