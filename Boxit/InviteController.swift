//
//  InviteController.swift
//  Boxxit
//
//  Created by Gabriel Coman on 26/10/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class InviteController: BaseController {

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
        
        let shareContent = "Invite Message".localized
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
}
