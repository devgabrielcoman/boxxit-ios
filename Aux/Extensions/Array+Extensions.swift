import UIKit

public extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            swap(&self[$0], &self[index])
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    public func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}

public extension Array where Element : Equatable {
    public var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

public extension Array where Element : Hashable {
    
    public func mapToDictionary (_ callback: @escaping (() -> Any)) -> [Element:Any] {
        
        var dict: [Element:Any] = [:]
        
        self.forEach { element in
            dict[element] = callback()
        }
        
        return dict
        
    }
}
