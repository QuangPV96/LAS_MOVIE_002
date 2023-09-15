import Foundation

struct ActingHistory {
    let title: String
    let character: String
    let releaseTimestamp: TimeInterval
    
    var yearText: String {
        let date = Date(timeIntervalSince1970: releaseTimestamp)
        return UtilService.yearFormatter.string(from: date)
    }
}
