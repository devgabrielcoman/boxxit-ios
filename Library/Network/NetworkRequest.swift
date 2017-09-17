//
//  BackendRequest2.swift
//  Boxit
//
//  Created by Gabriel Coman on 19/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import FBSDKCoreKit
import IDZSwiftCommonCrypto

public enum NetworkOperation {
    // 
    // requests directly to Facebook
    case getProfileFromFacebook(forUser: String)    // maybe this will be removed!
    case getFriendsFromFacebook(forUser: String, offset: String?)
    //
    // requests towards Boxxit backend
    case populateUserProfile(token: String)
    case saveNotificationToken(id: String, token: String?)
    case saveProduct(id: String, asin: String)
    case deleteProduct(id: String, asin: String)
    case getProductsForUser(id: String, min: Int?, max: Int?)
    case getFavouriteProductsForUser(id: String)
}

public class NetworkRequest: Request {
    
    var operation: NetworkOperation
    
    init(withOperation operation: NetworkOperation) {
        self.operation = operation
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var proto: String {
        return "https://"
    }
    
    var domain: String {
        switch operation {
        case .getProfileFromFacebook(_), .getFriendsFromFacebook(_, _):
            return "graph.facebook.com/v2.8"
        default:
            return "boxxit-3231.nodechef.com"
        }
    }
    
    var path: String {
        switch operation {
        case .getProfileFromFacebook(let user):
            return "/\(user)"
        case .getFriendsFromFacebook(let user, _):
            return "/\(user)/friends"
        case .populateUserProfile(_):
            return "/populateUserProfile"
        case .saveNotificationToken(_, _):
            return "/saveToken"
        case .saveProduct(_, _):
            return "/saveProduct"
        case .deleteProduct(_, _):
            return "/deleteProduct"
        case .getProductsForUser(_):
            return "/getProductsForUser"
        case .getFavouriteProductsForUser(_):
            return "/getFavouriteProductsForUser"
        }
    }
    
    var params: [String : Any] {
        switch operation {
        case .getProfileFromFacebook(_):
            return [
                "fields" : "email,gender,name,picture.width(300),first_name,last_name,birthday,friends{id}",
                "access_token": token
            ]
        case .getFriendsFromFacebook(_, let offset):
            return [
                "fields" : "id,email,picture.width(300),name,birthday,cover",
                "access_token": token,
                "after": offset ?? "",
//                "limit": 0,
                "summary": "true"
            ]
        case .populateUserProfile(let fbToken):
            return [
                "fbToken": fbToken
            ]
        case .saveNotificationToken(let id, let token):
            var result = ["fbId":id]
            if let token = token {
                result["token"] = token
            }
            return result
        case .saveProduct(let id, let asin):
            return [
                "fbId": id,
                "asin": asin
            ]
        case .deleteProduct(let id, let asin):
            return [
                "fbId": id,
                "asin": asin
            ]
        case .getProductsForUser(let id, let min, let max):
            var result: [String:Any] = [:]
            result["fbId"] = id
            if let min = min, let max = max  {
                result["min"] = min
                result["max"] = max
            }
            return result
        case .getFavouriteProductsForUser(let id):
            return [
                "fbId": id
            ]
        }
    }
    
    var query: String {
        return params.map { key, value in
            return "\(key)=\(self.removeEscapes(fromHeaderValue: value))"
        }.joined(separator: "&")
    }
    
    var body: [String:Any] {
        return [:]
    }
    
    var url: String {
        return "\(proto)\(domain)\(path)?\(query)"
    }
    
    var error : Error { return
        BoxitError.NoInternet
    }
}

//
// Extension for Facebook variables
extension NetworkRequest {
    var token: String {
        return FBSDKAccessToken.current().tokenString
    }
}


//
// Extension for Remove escapes method variables
extension NetworkRequest {
 
    func removeEscapes(fromHeaderValue value: Any) -> Any {
        
        if value is String {
            
            guard let percentEscaped = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return value
            }
            
            return percentEscaped.replacingOccurrences(of: ",", with: "%2C").replacingOccurrences(of: ":", with: "%3A")
            
        } else {
            return value
        }
    }
}
