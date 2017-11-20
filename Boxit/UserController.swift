//
//  UserController.swift
//  Boxxit
//
//  Created by Gabriel Coman on 20/11/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class UserController: BaseController {

    @IBAction func didSwipe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
