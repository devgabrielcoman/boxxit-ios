import Foundation
import ObjectMapper

class BackendData <T:Mappable> : Mappable {

    var data: [T] = []
    var total: Int?
    var done: Bool?
    
    required init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        data <- map["data"]
        total <- map["total"]
        done <- map["done"]
    }
}
