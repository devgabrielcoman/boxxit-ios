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

extension State {
    enum Favourite {
        case initial
        case success(withViewModels: [Product])
        case error(withViewModel: ViewModels.DataLoadError)
    }
}

//
// MARK: Base
class FavouriteController: BaseController {

    var facebookUser = "me"
    
    @IBOutlet weak var favouritesTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    fileprivate var rxFavouritesTable: RxTableView?
    fileprivate var mProducts:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.Favourite.initial)
        getProducts()
    }
}

//
// MARK: Business Logic
extension FavouriteController: BusinessLogic {
    
    func getProducts() {
        
        //
        // @todo: this should not be the case here
        guard let user = DataStore.shared.get(userForId: facebookUser) else {
            return
        }

        ProductsWorker.get(favouriteProductsForUserId: user.id)
            .toArray()
            .catchErrorAndContinue { error in
                let vm = ViewModels.DataLoadError(hasRetry: true, errorText: "Favourites Error".localized)
                self.setState(state: State.Favourite.error(withViewModel: vm))
            }
            .subscribeNext { products in
                
                // if it's all 0, show this
                if products.count == 0 {
                    let vm = ViewModels.DataLoadError(hasRetry: false, errorText: "Favourites No Fav".localized)
                    self.setState(state: State.Favourite.error(withViewModel: vm))
                }
                // if not, all good, go ahead
                else {
                    self.setState(state: State.Favourite.success(withViewModels: products))
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func openProductPage(withUrl url: URL?) {
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func delete(product: Product, atIndex index: Int) {
        
        //
        // @todo: this should not be the case here
        guard let user = DataStore.shared.get(userForId: facebookUser) else {
            return
        }
        
        ProductsWorker.delete(favouriteProduct: product.asin, forUserId: user.id)
            .do(onSubscribed: {
                // start the deletion process now, hoping it's going to be OK
                self.mProducts.remove(at: index)
                self.rxFavouritesTable?.update(withData: self.mProducts)
            })
            .subscribe(onSuccess: {
                // do nothing
            }, onError: { error in
                // revert change
                self.mProducts.insert(product, at: index)
                self.rxFavouritesTable?.update(withData: self.mProducts)
            })
            .addDisposableTo(disposeBag)
    }
}

//
// MARK: State
extension FavouriteController: StateLogic {
    
    func setState(state: State.Favourite) {
        switch state {
        // 
        // initial state
        case .initial:
            
            rxFavouritesTable = RxTableView.create()
                .bind(toTable: favouritesTable)
                .customise(rowForReuseIdentifier: FavouriteRow.Identifier, andHeight: UITableViewAutomaticDimension) { (index, row: FavouriteRow, model: Product, total) in
                    row.title.text = model.title
                    row.price.text = model.price
                    row.icon.kf.setImage(with: model.largeIconUrl)
                    row.separator.isHidden = index.row == total - 1
                }
                .did(clickOnRowWithReuseIdentifier: FavouriteRow.Identifier) { (index, model: Product) in
                    self.openProductPage(withUrl: model.clickUrl)
                }
                .can(editRowWithReuseIdentifier: FavouriteRow.Identifier) { (index, model: Product) -> Bool in
                    return self.facebookUser == "me"
                }
                .commit(editForRowWithReuseIdentifier: FavouriteRow.Identifier) { (index, style, model: Product) in
                    if style == .delete {
                        self.delete(product: model, atIndex: index.row)
                    }
                }
            
            break
        //
        // success state
        case .success(let viewModels):
            
            // hold a local copy (for deletions, changes, etc)
            self.mProducts = viewModels
            
            //
            // stop animating
            spinner.stopAnimating()
            
            //
            // set previous error controller invisible
            let controller: ErrorController? = self.getChild()
            controller?.setState(state: State.Error.hidden)
            
            //
            // update data
            rxFavouritesTable?.update(withData: viewModels)
            
            break
        //
        // error state
        case .error(let viewModel):
            
            spinner.stopAnimating()
            
            let controller: ErrorController? = self.getChild()
            controller?.setState(state: State.Error.visible(withErrorMessage: viewModel.errorText, andHasRetryButton: viewModel.hasRetry, andRetryButtonText: nil))
            
            break
        }
    }
}

//
// MARK: Routing Logic
extension FavouriteController: FavouriteRoutingLogic {
    
    func embed(controller1: ProfileHeaderController) {
        controller1.facebookUser = facebookUser
        controller1.hasInfoButton = false
    }
    
    func embed(controller2: ErrorController) {
        controller2.didClickOnRetry = {
            controller2.setState(state: State.Error.hidden)
            self.spinner.startAnimating()
            self.getProducts()
        }
    }
}
