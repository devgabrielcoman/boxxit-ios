//
//  Style.swift
//  Boxit
//
//  Created by Gabriel Coman on 13/07/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIButton {
    
    func loginStyle () {
        
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        
    }
    
    func welcomeButton () {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(rgb: 0x0F2A42).cgColor
        self.layer.cornerRadius = 20
        self.setTitleColor(UIColor(rgb: 0x0F2A42), for: .normal)
    }
}
