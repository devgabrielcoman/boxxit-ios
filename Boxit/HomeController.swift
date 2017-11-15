//
//  HomeController.swift
//  Boxxit
//
//  Created by Gabriel Coman on 08/11/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class HomeController: BaseController {

    // do nothing
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var footerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.addListener(self)
    }
    
    override func handle(_ state: AppState) {
        let state = state.friendsState
        footerContainer.isHidden = state.friends.count == 0
        footerHeight.constant = state.friends.count > 0 ? 60 : 0
    }
    
    deinit {
        store.removeListener(self)
    }
}
