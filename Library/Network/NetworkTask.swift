import Foundation
import RxSwift
import Alamofire

public class NetworkTask: Task {
    
    public typealias Input = NetworkRequest
    public typealias Output = String
    public typealias Result = Single<Output>
    
    public func execute(withInput input: NetworkRequest) -> Single<String> {
        
        print(input.url)
        
        return Single<String>.create { single -> Disposable in
            
            Alamofire.request(input.url, method: input.method, parameters: input.body, encoding: URLEncoding.default, headers: nil).responseString { response in
             
                if let response = response.result.value {
                    single(.success(response))
                } else {
                    single(.error(input.error))
                }
            }
            
            return Disposables.create()
            
        }
    }
    
    public init() {
        // do nothing
    }
    
}
