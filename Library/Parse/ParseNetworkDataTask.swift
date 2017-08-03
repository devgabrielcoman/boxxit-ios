import Foundation
import RxSwift
import ObjectMapper

class ParseNetworkDataTask<Data: Mappable>: Task {

    typealias Input = ParseRequest
    typealias Output = BackendData<Data>
    typealias Result = Single<Output>
    
    func execute(withInput input: ParseRequest) -> Single<BackendData<Data>> {
        
        return Single<BackendData<Data>>.create { single -> Disposable in
            
            if let data = BackendData<Data>(JSONString: input.rawData) {
                single(.success(data))
            } else {
                single(.error(BoxitError.ParseError))
            }
            
            return Disposables.create()
        }
    }
}
