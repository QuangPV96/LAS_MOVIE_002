import UIKit

struct VideoTrailer: Decodable, Identifiable {
    let id: Int
    let key: String
    let type: String
    
    var dictionary : NSDictionary {
        return [
            "id":id,
            "key":key,
            "type":type,
        ]
    }
    
}
