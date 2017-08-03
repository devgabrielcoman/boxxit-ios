import Foundation
import RxSwift
import FBSDKCoreKit
import ObjectMapper

class ParseFacebookDataTask<Data: Mappable> : Task {
    
    typealias Input = ParseRequest
    typealias Output = FacebookData<Data>
    typealias Result = Single<Output>
    
    func execute(withInput input: ParseRequest) -> Single<FacebookData<Data>> {
        
        return Single<FacebookData<Data>>.create { single -> Disposable in
            
            if let data = FacebookData<Data>(JSONString: input.rawData) {
                single(.success(data))
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
