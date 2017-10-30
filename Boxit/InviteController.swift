//
//  InviteController.swift
//  Boxxit
//
//  Created by Gabriel Coman on 26/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import FBSDKShareKit

class InviteController: BaseController, FBSDKAppInviteDialogDelegate {

    @IBOutlet weak var inviteText: UILabel?
    @IBOutlet weak var bigInviteText1: UILabel?
    @IBOutlet weak var bigInviteText2: UILabel?
    @IBOutlet weak var inviteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteText?.text = "Invite Invite Text".localized
        bigInviteText1?.text = "Big Invite Text 1".localized
        bigInviteText2?.text = "Big Invite Text 2".localized
        inviteButton?.setTitle("Invite Invite Button".localized, for: .normal)
    }
    
    @IBAction func inviteAction() {
        
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
