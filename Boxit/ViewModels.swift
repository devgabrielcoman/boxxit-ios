//
//  Models.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

struct ViewModels {
    
    class User {
        var profile: FacebookProfile
        
        var birthdayShort: String {
            get {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, MMM d, yyyy"
                let today = Date()
                let birthdayStr = profile.nextBirthday
                let todayStr = formatter.string(from: today)
                
                if let birthdayStr = birthdayStr {
                    if birthdayStr == todayStr {
                        return "Birthday Today Message".localized
                    } else {
                        return birthdayStr
                    }
                } else {
                    return "Birthday No Message".localized
                }
            }
        }
        
        init(profile: FacebookProfile) {
            self.profile = profile
        }
    }
}
