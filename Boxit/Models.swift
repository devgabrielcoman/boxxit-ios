//
//  Models.swift
//  Boxit
//
//  Created by Gabriel Coman on 09/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

struct ViewModels {
    
    struct DataLoadError {
        var hasRetry = false
        var errorText: String
    }
    
    class User {
        var profile: FacebookProfile
        
        var birthdayShort: String {
            get {
                let result = profile.timeUntilBirthday
                
                if result.interval == .Today {
                    return "Birthday Today Message".localized
                }
                else if result.interval == .Days {
                    return String(format: "Birthday This Week Message", result.distance)
                }
                else {
                    return profile.nextBirthday
                }
            }
        }
        
        init(profile: FacebookProfile) {
            self.profile = profile
        }
    }
    
    class Invite {
        init() {
            // do nothing
        }
    }
}
