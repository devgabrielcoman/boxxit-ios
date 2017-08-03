import Foundation
import RxSwift
import FBSDKCoreKit
import FBSDKLoginKit

public class FacebookAuthTask: Task {
    
    public typealias Input = FacebookAuthRequest
    public typealias Output = String
    public typealias Result = Single<Output>
    
    public func execute(withInput input: FacebookAuthRequest) -> Single<String> {
        
        return Single<String>.create { single -> Disposable in
         
            FBSDKLoginManager().logIn(withReadPermissions: input.permissions, from: input.viewController) { result, error in
                
                if error != nil {
                    single(.error(BoxitError.FbAuthError))
                }
                else if let result = result {
                    if result.isCancelled {
                        single(.error(BoxitError.FbAuthCancelled))
                    } else {
                        if let fbsdktoken = FBSDKAccessToken.current(),
                           let token = fbsdktoken.tokenString {
                            
                            print("Token is \(token)")
                            
                            single(.success(token))
                            
                        } else {
                            print("Fb Error is \(error)")
                            single(.error(BoxitError.FbAuthError))
                        }
                    }
                }
                else {
                    single(.error(BoxitError.FbAuthError))
                }
            }
            
            return Disposables.create()
        }
    }
    
    public init() {
        // do nothing
    }
}
