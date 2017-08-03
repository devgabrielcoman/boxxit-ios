//
//  ProfileHeaderRouter.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

protocol ProfileHeaderRoutingLogic: RoutingLogic {
    func prepare(controller: FavouriteController)
}

extension ProfileHeaderController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? FavouriteController {
            self.prepare(controller: dest)
        }
    }
}
