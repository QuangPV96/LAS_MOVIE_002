import Foundation
import UIKit

let prefix_host_image = "https://image.tmdb.org/t/p/w500"
let prefix_host_themoviedb = "https://api.themoviedb.org/3/"
let prefixSrcImage = "data:image/jpeg;"

public typealias MoDictionary = [String:Any?]
public typealias MoAnyHashable = [AnyHashable : Any]

public enum AdsName: String {
    case admob, applovin
}

public enum AdsUnit: String {
    case banner, native, interstitial, open, reward
}

enum PMError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case none
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch data"
        case .invalidEndpoint:
            return "Invalid endpoit"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        case .none:
            return "An error occurs"
        }
    }
    
    var errorUserInfo: [String : Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

let not_available = "N/A"
let bullet_symbol = "•"

let number_data_collapse = 7

func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

public func widthForLabel(text:String, font:UIFont, height:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.width
}
