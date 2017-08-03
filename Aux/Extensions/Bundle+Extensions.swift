import UIKit

extension Bundle {
    
    func plistDictionary(forFile file: String) -> [String:String] {
        if let path = self.path(forResource: file, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String:String] {
            return dict
        } else {
            return [:]
        }
    }
    
}
