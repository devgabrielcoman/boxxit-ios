import Foundation
import RxSwift
import ObjectMapper

class ParseNetworkDataTask<Data: Mappable>: Task {

    typealias Input = String
    typealias Output = BackendData<Data>
    typealias Result = Single<Output>
    
    func execute(withInput input: String) -> Single<BackendData<Data>> {
        
        return Single<BackendData<Data>>.create { single -> Disposable in
            
            if let data = BackendData<Data>(JSONString: input) {
                single(.success(data))
            } else {
                single(.error(BoxitError.ParseError))
            }
            
            return Disposables.create()
        }
    }
}
