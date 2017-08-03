import UIKit

private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    private func check(dictionary dict: NSDictionary, forKey k: String) -> Any? {
        
        for (key, value) in dict {
            
            if let toCheck = key as? String, toCheck.isEqual(k) {
                return value
            }
            
            if let v = value as? NSDictionary, let possible = check(dictionary: v, forKey: k) {
                return possible
            }
        }
        
        return nil
    }
    
    func localize(_ string: String) -> String {
        
        if let dict = localizableDictionary {
            
            guard let localisedString = check(dictionary: dict, forKey: string) else {
                assertionFailure("Missing translation for: \(string)")
                return ""

            }
            return localisedString as! String
            
        }
        return ""
    }
}

public extension String {
    public var localized: String {
        return Localizator.sharedInstance.localize(self)
    }
}
