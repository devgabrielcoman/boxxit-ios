//
//  ExploreController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxTableAndCollectionView
import Alertift
import Firebase

extension State {
    enum Explore {
        case initial
        case success(viewViewModels: [Any])
        case error(withViewModel: ViewModels.DataLoadError)
    }
}

//
// MARK: Base
class ExploreController: BaseController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var rxTableView: RxTableView?
    
    @IBOutlet weak var loadingIcon: UIImageView!
    
    @IBOutlet weak var sliderContainer: UIView!
    
    var facebookUser: String = "me"
    
    fileprivate var minPrice: Int?
    fileprivate var maxPrice: Int?
    fileprivate var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setState(state: State.Explore.initial)
        self.getProducts()
    }
}

//
// MARK: Business Logic
extension ExploreController: BusinessLogic {
    
    func getProducts() {
        
        UserWorker.get(profileForUserId: facebookUser)
            .subscribe(onSuccess: { profile in
                
                ProductsWorker.get(productsForUserId: profile.id, withMinPrice: self.minPrice, andMaxPrice: self.maxPrice)
                    .filter { product -> Bool in
                        
                        for i in 0..<self.products.count {
                            if product.asin == self.products[i].asin {
                                return false
                            }
                        }

                        return true
                    }
                    .toArray()
                    .subscribe(onNext: { models in
                        
                        // accumulate
                        self.products += models
                        
                        // somehow still no products - means it's error
                        if self.products.count == 0 {
                            let vm = ViewModels.DataLoadError(hasRetry: true, errorText: "Product Error Message".localized)
                            self.setState(state: State.Explore.error(withViewModel: vm))
                        }
                        // final success case
                        else {
                            self.setState(state: State.Explore.success(viewViewModels: self.products))
                        }
                        
                    }, onError: { error in
                        let vm = ViewModels.DataLoadError(hasRetry: true, errorText: "Product Error Message".localized)
                        self.setState(state: State.Explore.error(withViewModel: vm))
                    })
                    .addDisposableTo(self.disposeBag)
            })
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
}

//
// MARK: State Logic 
extension ExploreController: StateLogic {
    
    func setState(state: State.Explore) {
        switch state {
        // 
        // initial state
        case .initial:
            
            rxTableView = RxTableView.create()
                .bind(toTable: tableView)
                .customise(rowForReuseIdentifier: ProductRow.Identifier, andHeight: UITableViewAutomaticDimension) { (index, row: ProductRow, product: Product, total) in
                    
                    row.productName.text = product.title
                    
                    row.productReason.text = String(format: self.facebookUser == "me" ?
                                                            product.isOwn ? "Product Reason - Sure - You".localized : "Product Reason - Maybe - You".localized :
                                                            product.isOwn ? "Product Reason - Sure - Friend".localized : "Product Reason - Maybe - Friend".localized,
                                                    product.category.capitalized)
                    
                    row.productPrice.text = product.price
                    row.getOnAmazonLabel.text = "Buy Amazon".localized
                    row.productPicture.kf.setImage(with: product.largeIconUrl, placeholder: UIImage(named: "no_ama_pic"))
                    row.saveToFavourites.isHidden = self.facebookUser != "me"
                    row.saveToFavourites.setImage(product.isFavourite ? UIImage(named: "like") : UIImage(named: "nolike"), for: .normal)
                    row.buttonHolder.layer.borderWidth = 1
                    row.buttonHolder.layer.borderColor = UIColor(rgb: 0x0f2a42).cgColor
                    
                    // when clicking on "buy", user is redirected to Amazon website
                    row.getOnAmazon.onAction {
                        
                        //
                        // open page
                        self.openProductPage(withUrl: product.clickUrl)
                        
                        //
                        // get current user
                        guard let ownId = DataStore.shared.getOwnId() else { return }
                        guard let user = DataStore.shared.get(userForId: self.facebookUser) else { return }
                        
                        //
                        // prep data
                        let data = [
                            "user_id": ownId,
                            "friend_id": user.id,
                            "friend_name": user.name,
                            "product_id": product.asin,
                            "product_name": product.title
                        ]
                        
                        //
                        // send analytics
                        Analytics.logEvent("view_product", parameters: data)
                    }
                    
                    // favourites
                    row.saveToFavourites.onAction {
                        
                        //
                        // @todo: this should not be the case here
                        guard let user = DataStore.shared.get(userForId: self.facebookUser) else {
                            return
                        }
                        
                        let rxOperation = product.isFavourite ?
                        ProductsWorker.delete(favouriteProduct: product.asin, forUserId: user.id) :
                        ProductsWorker.save(favouriteProduct: product.asin, forUserId: user.id)
                        
                        rxOperation
                            .do(onSubscribed: {
                                product.isFavourite = !product.isFavourite
                                row.saveToFavourites.setImage(product.isFavourite ? UIImage(named: "like") : UIImage(named: "nolike"), for: .normal)
                            })
                            .subscribe(onError: { error in
                                product.isFavourite = !product.isFavourite
                                row.saveToFavourites.setImage(product.isFavourite ? UIImage(named: "like") : UIImage(named: "nolike"), for: .normal)
                            })
                            .addDisposableTo(self.disposeBag)
                    }
                }
                .did(reachEnd: {
                    self.getProducts()
                })
            
            break
        //
        // success case
        case .success(let viewModels):
            
            self.loadingIcon.isHidden = true
            self.rxTableView?.update(withData: viewModels)
            break
        //
        // error case
        case .error(let viewModel):
            
            self.loadingIcon.isHidden = true
            let controller: ErrorController? = self.getChild()
            controller?.setState(state: State.Error.visible(withErrorMessage: viewModel.errorText, andHasRetryButton: viewModel.hasRetry, andRetryButtonText: nil))
            break
        }
    }
}

//
// MARK: Routing Logic
extension ExploreController: ExploreRoutingLogic {
    
    func embed(controller1: SliderController) {
        controller1.didSlideCallback = { min, max in
            self.minPrice = min * 100
            self.maxPrice = max * 100
            self.loadingIcon.isHidden = false
            self.rxTableView?.update(withData: [])
            self.products = []
            self.getProducts()
        }
    }
    
    func embed(controller2: ErrorController) {
        controller2.didClickOnRetry = {
            controller2.setState(state: State.Error.hidden)
            self.loadingIcon.isHidden = false
            self.getProducts()
        }
    }
}
