import UIKit

public class FacebookAuthRequest: Request {

    var viewController: UIViewController
    
    var permissions: [String] {
        get {
            return ["public_profile",
                    "email",
                    "user_friends",
                    "user_likes",
                    "user_birthday"]
        }
    }
    
    public init(withViewController viewController: UIViewController) {
        self.viewController = viewController
    }
    
}
