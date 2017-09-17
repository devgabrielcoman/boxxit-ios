import UIKit

public enum BirthdayInterval: Int {
    case Invalid = -1
    case Today = 0
    case Days = 1
    case Weeks = 2
    case Months = 3
    case FarAway = 4
}

public extension Date {
    
    public static func from(facebookDate date: String?) -> Date? {
        
        guard let date = date, date != "" else {
            return nil
        }
        
        let components = date.components(separatedBy: "/")
        
        let formatter = DateFormatter()
        
        if components.count == 1 {
            formatter.dateFormat = "y"
        } else if components.count == 2 {
            formatter.dateFormat = "MM/dd"
        } else {
            formatter.dateFormat = "MM/dd/yyyy"
        }
        
        return formatter.date(from: date)!
    }
    
    var timeUntilBirthday: (distance: Int, interval: BirthdayInterval) {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let current = Date()
            
            let calendar = Calendar.current
            
            let bday = calendar.component(.day, from: self)
            let bmonth = calendar.component(.month, from: self)
            let cyear = calendar.component(.year, from: current)
            
            let next = formatter.date(from: "\(bmonth)/\(bday)/\(cyear)")
            
            var days = calendar.dateComponents([.day], from: current, to: next!).day!
            days = days < 0 ? (days + 365) : days
            
            // case today
            if days == 0 {
                return (0, .Today)
            }
                // less than a week
            else if days > 0 && days <= 7 {
                return (days, .Days)
            }
                // less than a month
            else if days > 7 && days <= 30 {
                let weeks = calendar.dateComponents([.weekOfMonth], from: current, to: next!).weekOfMonth!
                return (weeks, .Weeks)
            }
                // between 1 month and 3 months
            else if days > 30 && days <= 90 {
                let month = calendar.dateComponents([.month], from: current, to: next!).month!
                return (month, .Months)
            }
                // really far away
            else {
                return (0, .FarAway)
            }
        }
    }
    
    var nextBirthday: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let current = Date()
            let calendar = Calendar.current
            
            let bday = calendar.component(.day, from: self)
            let bmonth = calendar.component(.month, from: self)
            let cyear = calendar.component(.year, from: current)
            var next = formatter.date(from: "\(bmonth)/\(bday)/\(cyear)")
            
            let days = calendar.dateComponents([.day], from: current, to: next!).day!
            let ryear = days < 0 ? cyear + 1 : cyear
            
            next = formatter.date(from: "\(bmonth)/\(bday)/\(ryear)")
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            
            return formatter.string(from: next!)
        }
    }
}
