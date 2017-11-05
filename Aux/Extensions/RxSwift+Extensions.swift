import Foundation
import RxSwift

typealias Service<T> = PublishSubject<T>

extension Service {
    
    func listen () -> Observable<PublishSubject.E> {
        return self.asObservable()
    }
    
    func next(value: PublishSubject.E) {
        self.onNext(value)
    }
}
