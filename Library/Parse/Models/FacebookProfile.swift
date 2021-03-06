import UIKit
import ObjectMapper

public class FacebookProfile: Mappable {

    public var id: String = ""
    public var name: String = ""
    public var birthday: String = ""
    
    public var email: String?
    public var firstName: String?
    public var gender: String?
    public var picture: String?
    public var friends: [Any] = []
    
    init() {
        // do nothing
    }
    
    required public init?(map: Map) {
        // validation
        if map.JSON["id"] == nil {
            return nil
        }
        if map.JSON["name"] == nil {
            return nil
        }
//        if map.JSON["birthday"] == nil {
//            return nil
//        }
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        birthday <- map["birthday"]
        name <- map["name"]
        
        email <- map["email"]
        firstName <- map["first_name"]
        gender <- map["gender"]
        picture <- map["picture.data.url"]
        friends <- map["friends.data"]
    }
}

//
// birthday extensions
extension FacebookProfile {
    
    var birthdayDate: Date? {
        get {
            return Date.from(facebookDate: birthday)
        }
    }
    
    var nextBirthday: String? {
        get {
            return birthdayDate?.nextBirthday
        }
    }
}

//
// picture extensions
extension FacebookProfile {
    
    var pictureUrl: URL? {
        get {
            guard let pic = picture else { return nil }
            return URL(string: pic)
        }
    }
}
