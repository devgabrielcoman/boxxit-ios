//
//  TransparentView.swift
//  Boxxit
//
//  Created by Gabriel Coman on 03/11/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIView {
    static func transparentView () -> UIView {
        let view = UIView ()
        view.backgroundColor = UIColor.clear
        return view
    }
}
