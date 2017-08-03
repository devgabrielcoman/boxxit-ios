//
//  DataStore.swift
//  Boxit
//
//  Created by Gabriel Coman on 11/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class DataStore {

    static let shared = DataStore()
    
    private init () {}
    
    // dictionary of stored profiles
    private var profiles: [String:FacebookProfile] = [:]
    
    func save(user profile: FacebookProfile, forId id: String) {
        profiles[id] = profile
    }
    
    func get(userForId id: String) -> FacebookProfile? {
        return profiles[id]
    }
}
