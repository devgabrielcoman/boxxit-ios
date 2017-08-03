import Foundation
import ObjectMapper

class Product: Mappable {

    var asin: String = "N/A"
    var title: String = "N/A"
    var amount: Int = 0
    var price: String = "N/A"
    var click: String = "N/A"
    
    var smallIcon: String?
    var largeIcon: String?
    
    var isFavourite: Bool = false
    var category: String = "N/A"
    
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        asin <- map["asin"]
        title <- map["title"]
        amount <- map["amount"]
        price <- map["price"]
        click <- map["click"]
        smallIcon <- map["smallIcon"]
        largeIcon <- map["largeIcon"]
        isFavourite <- map["isFavourite"]
        category <- map["categId"]
    }
}

extension Product {
    
    var clickUrl: URL? {
        get {
            return URL(string: click)
        }
    }
    
    var smallIconUrl: URL? {
        get {
            guard let val = smallIcon else {
                return nil
            }
            return URL(string: val)
        }
    }
    
    var largeIconUrl: URL? {
        get {
            guard let val = largeIcon else {
                return nil
            }
            return URL(string: val)
        }
    }
}
