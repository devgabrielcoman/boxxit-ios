//
//  ErrorController.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

extension State {
    enum Error {
        case initial
        case hidden
        case visible(withErrorMessage: String, andHasRetryButton: Bool, andRetryButtonText: String?)
    }
}

//
// MARK: Base
class ErrorController: BaseController {

    @IBOutlet weak var retryButtonBContraint: NSLayoutConstraint!
    @IBOutlet weak var retryButtonHContraint: NSLayoutConstraint!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var didClickOnRetry: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState(state: State.Error.initial)
        setState(state: State.Error.hidden)
    }
}

//
// MARK: Business Logic
extension ErrorController: BusinessLogic {
    
    @IBAction func retryAction(sender: Any) {
        didClickOnRetry?()
    }
    
    func show () {
        self.view.superview?.isUserInteractionEnabled = true
        self.view.isHidden = false
    }
    
    func hide () {
        self.view.superview?.isUserInteractionEnabled = false
        self.view.isHidden = true
    }
}

//
// MARK: State Logic
extension ErrorController: StateLogic {
    
    func setState(state: State.Error) {
        switch state {
        // 
        // initial state
        case .initial:
            retryButton.setTitle("Retry Button".localized, for: .normal)
            break
        //
        // hidden state
        case .hidden:
            self.view.superview?.isUserInteractionEnabled = false
            self.view.isHidden = true
            break
        // visible state
        case .visible(let message, let show, let buttonTitle):
            
            //
            // make view visible
            self.view.superview?.isUserInteractionEnabled = true
            self.view.isHidden = false
            
            textLabel.text = message
            
            //
            // set if it's shown or not
            retryButton.isHidden = !show
            
            //
            // override button title
            if let button = buttonTitle {
                retryButton.setTitle(button, for: .normal)
            }
            
            if !show {
                retryButtonBContraint.constant = 0
                retryButtonHContraint.constant = 0
            }
            break
        }
    }
    
}
