import Foundation

class ParseRequest: Request {
    
    var rawData: String
    
    init(withData data: String) {
        rawData = data
    }
    
}
