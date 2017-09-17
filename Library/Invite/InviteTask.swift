import UIKit
import RxSwift
import FBSDKShareKit

//public class InviteTask: NSObject, Task, FBSDKAppInviteDialogDelegate {
//    
//    public typealias Input = InviteRequest
//    public typealias Output = Void
//
//    private var service = Service<Void>()
//    
//    public func execute(withInput input: InviteRequest) -> Observable<Void> {
//        
//        let content = FBSDKAppInviteContent()
//        content.appLinkURL = input.inviteUrl
//        content.appInvitePreviewImageURL = input.previewUrl
//        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
//        
//        return service.listen()
//        
//    }
//    
//    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
//        print("Results are \(results)")
//        service.next(value: ())
//    }
//    
//    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
//        print("Complete with error \(error)")
//        service.onError(BoxitError.InviteError)
//    }
//    
//    public override init() {
//        super.init()
//    }
//    
//}
