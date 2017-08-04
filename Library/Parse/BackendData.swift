import Foundation
import ObjectMapper

class BackendData <T:Mappable> : Mappable {

    var data: [T] = []
    var count: Int?
    var done: Bool?
    
    required init?(map: Map) {
        // do nothing
    }
    
    public func mapping(map: Map) {
        data <- map["data"]
        count <- map["count"]
        done <- map["done"]
    }
}
