//
//  FavouritesRouter.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

protocol FavouriteRoutingLogic: RoutingLogic {
    func embed(controller1: ProfileHeaderController)
    func embed(controller2: ErrorController)
}

extension FavouriteController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let embed = segue.destination as? ProfileHeaderController {
            self.embed(controller1: embed)
        }
        
        if let embed = segue.destination as? ErrorController {
            self.embed(controller2: embed)
        }
    }
    
}
