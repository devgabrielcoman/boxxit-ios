import Foundation
import RxSwift
import FBSDKCoreKit
import ObjectMapper

class ParseFacebookProfileTask: Task {

    typealias Input = String
    typealias Output = FacebookProfile
    typealias Result = Single<Output>
    
    func execute(withInput input: String) -> Single<FacebookProfile> {
        
        return Single<FacebookProfile>.create { single -> Disposable in
            
            if let profile = FacebookProfile(JSONString: input)  {
                single(.success(profile))
            } else {
                single(.error(BoxitError.ParseError))
            }
            
            return Disposables.create()
            
        }
    }
    
    init() {
        // do nothing
    }
}
