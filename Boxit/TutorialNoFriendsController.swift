//
//  TutorialNoFriendsController.swift
//  Boxit
//
//  Created by Gabriel Coman on 29/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import FBSDKShareKit

class TutorialNoFriendsController: BaseController {

    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var exploreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialText.text = "Tutorial No Friends Text".localized
        exploreButton.setTitle("No Friends Action".localized, for: .normal)
    }
}

//
// MARK: Business Logic
extension TutorialNoFriendsController: FBSDKAppInviteDialogDelegate {
    
    @IBAction func exploreAction(_ sender: Any) {
        // TutorialDriver.shared.drivenAction?()
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        
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
