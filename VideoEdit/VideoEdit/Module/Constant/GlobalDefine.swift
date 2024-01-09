import Foundation
import UIKit

struct AppSetting {
    static let id = ""
    static let email = "daian3001@gmail.com"
    static let homepage = "https://daian3001.github.io"
    static let privacy = "https://daian3001.github.io/privacy.html"
    static let list_ads = "https://daian3001.github.io/list-adses.json"
    static let appKey = "889585381e90daa9d3c283990a15abb561264c30"
    static let appRateKey = "659cbf1173d38f801b058489"
    static let secretSalt = "cc088426cbe33d11b973caca17b37377"
    static let checkingLink = "https://countlytics.info"
    static let widgetID = ""
    static let key_movie_db = "194603623f3b6d81db9e7c24fa2feab7"
    static let titleNoti = "Dozer Video"
    static let contentNoti = "Dozer Video Watch Movie & TV Show"
    
    public static func getIDDevice() -> String {
        let key = "keysclientid"
        if AniKeychain.getString(forKey: key) == nil {
            let uuid = UUID().uuidString
            _ = AniKeychain.setString(value: uuid, forKey: key)
        }
        return AniKeychain.getString(forKey: key) ?? ""
    }
    
}

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
