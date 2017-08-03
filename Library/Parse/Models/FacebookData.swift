import UIKit
import ObjectMapper

public class FacebookData <T: Mappable> : Mappable {
    
    public var data: [T] = []
    var after: String?
    var before: String?
    var next: String?
    var previous: String?
    var total: Int?
    
    public var offsetAfter: String? {
        get {
            guard next != nil else { return nil }
            return after
        }
    }
    
    public var offsetBefore: String? {
        get {
            guard previous != nil else { return nil }
            return before
        }
    }
    
    convenience init?(data: [String:Any]) {
        let map = Map(mappingType: MappingType.fromJSON, JSON: data)
        self.init(map: map)
    }
    
    required public init?(map: Map) {
        // validation
        if map.JSON["data"] == nil {
            return nil
        }
        guard (map.JSON["data"] as? [Any]) != nil else {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        data <- map["data"]
        after <- map["paging.cursors.after"]
        before <- map["paging.cursors.before"]
        next <- map["paging.next"]
        previous <- map["paging.previous"]
        total <- map["summary.total_count"]
    }
}
