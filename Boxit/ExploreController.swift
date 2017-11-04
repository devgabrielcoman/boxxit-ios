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
import Alertift
import Firebase

class ExploreController: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var sliderContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // setup
        let error: ErrorController? = getChild()
        error?.textLabel.text = "Product Error Message".localized
        error?.didClickOnRetry = { self.loadData() }
        
        //
        // add listener
        store.addListener(self)
        
        //
        // load data
        store.dispatch(Event.resetProducts)
        self.loadData()
    }
    
    func loadData () {
        if let userId = store.current.selectedUserState.user?.id {
            let min = store.current.productState.minPrice
            let max = store.current.productState.maxPrice
            store.dispatch(Event.get(productsForUserid: userId, withMinPrice: min, andMaxPrice: max))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // do nothing
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // do nothing
    }
    
    override func handle(_ state: AppState) {
        let productsState = state.productState
        tableView.isHidden = productsState.isLoading
        loadingIcon.isHidden = !productsState.isLoading
        errorContainerView.isHidden = productsState.error == nil
        tableView.reloadData()
    }
    
    deinit {
        store.removeListener(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let embed = segue.destination as? SliderController {
            embed.didSlideCallback = { min, max in
                self.store.dispatch(Event.updatePriceRange(withMin: min * 100, andMax: max * 100))
                self.loadData()
            }
        }
    }
}

extension ExploreController: UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.current.productState.products.count
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
        let row = tableView.dequeueReusableCell(withIdentifier: ProductRow.Identifier, for: indexPath) as! ProductRow
        row.viewModel = store.current.productState.products[indexPath.row]
        return row
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.bounds.maxY >= scrollView.contentSize.height {
            self.loadData()
        }
    }
}

