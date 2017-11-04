import Foundation
import RxSwift

extension ObservableType {

    public func subscribeNext (handler: @escaping (Self.E) -> Void) -> Disposable {
        return self.subscribe(onNext: handler)
    }
}

typealias Service<T> = PublishSubject<T>

extension Service {
    
    func listen () -> Observable<PublishSubject.E> {
        return self.asObservable()
    }
    
    func next(value: PublishSubject.E) {
        self.onNext(value)
    }
}
