//
//  ErrorController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

class ErrorController: BaseController {

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var didClickOnRetry: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retryButton.setTitle("Retry Button".localized, for: .normal)
    }
    
    @IBAction func retryAction(sender: Any) {
        didClickOnRetry?()
    }
}

