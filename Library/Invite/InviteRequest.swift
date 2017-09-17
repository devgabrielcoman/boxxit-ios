import Foundation
import FBSDKShareKit

public class InviteRequest: Request {
    
    private var inviteUrlString: String {
        return "https://fb.me/208626762984319"
    }
    
    private var previewUrlString: String {
        return "https://boxxit-3231.nodechef.com/fbpreviewimg.png"
    }
    
    var inviteUrl: URL! {
        return URL(string: inviteUrlString)
    }
    
    var previewUrl: URL! {
        return URL(string: previewUrlString)
    }
}
