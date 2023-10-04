import Foundation
import UIKit
class ActivityEx{
   static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    static func screenWidth() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth
    }
    static func screenHeight() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        return screenHeight
    }
    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

}
