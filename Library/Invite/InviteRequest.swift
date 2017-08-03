import Foundation
import FBSDKShareKit

public class InviteRequest: Request {
    
    var viewController: UIViewController
    
    public init(withViewController viewController: UIViewController) {
        self.viewController = viewController
    }
}
