import Foundation
import RxSwift

public protocol Task {
    associatedtype Input
    associatedtype Output
    associatedtype Result
    
    func execute(withInput input: Input) -> Result
}
