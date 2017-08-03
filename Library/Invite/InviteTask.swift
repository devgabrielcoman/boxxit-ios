import UIKit
import RxSwift
import FBSDKShareKit

public class InviteTask: NSObject, Task, FBSDKAppInviteDialogDelegate {
    
    public typealias Input = InviteRequest
    public typealias Output = Void

    private var service = Service<Void>()
    
    public func execute(withInput input: InviteRequest) -> Observable<Void> {
        
        let content = FBSDKAppInviteContent()
        content.appLinkURL = URL(string: "https://fb.me/208626762984319")
        content.appInvitePreviewImageURL = URL(string: "https://scontent-lht6-1.xx.fbcdn.net/v/t39.2081-0/p32x32/851578_455087414601994_1601110696_n.png?oh=513ff61f44b7a05b5cd2a57cf3584cdb&oe=59832DA7")
        FBSDKAppInviteDialog.show(from: input.viewController, with: content, delegate: self)
        
        return service.listen()
        
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Results are \(results)")
        service.next(value: ())
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Complete with error \(error)")
        service.onError(BoxitError.InviteError)
    }
    
    public override init() {
        super.init()
    }
    
}
