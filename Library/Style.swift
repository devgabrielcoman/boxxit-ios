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
        
        self.backgroundColor = UIColor(red: (7/255), green: (128/255), blue: (147/255), alpha: 1)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.35
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
    
    func welcomeButton () {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(rgb: 0x0F2A42).cgColor
        self.layer.cornerRadius = 20
        self.setTitleColor(UIColor(rgb: 0x0F2A42), for: .normal)
    }
}
