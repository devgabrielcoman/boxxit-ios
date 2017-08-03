//
//  CleanSwift.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import Foundation

protocol BusinessLogic {
    // do nothing
}

protocol ViewModelLogic {
    // do nothing
}

protocol StateLogic {
    // do nothing
}

protocol RoutingLogic {
    // do nothing
}

enum State {
    // empty state
}

extension State {
    enum MyState {
        case initial
        case error
    }
}
