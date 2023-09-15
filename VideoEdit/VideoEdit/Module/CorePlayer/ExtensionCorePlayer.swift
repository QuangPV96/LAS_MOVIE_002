import UIKit
import CommonCrypto

extension Date {
    public func toSring() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
}

import CryptoSwift

private let iv = "6f9bbc19f78f980f"
private let key = "cb4b10abaadd1e422b15ff7586307842"
public let emptylink = (try? "9EyuhW1AfiHgoKlhrQNq1NxtFIPvSqTsVkPHTHAxOZWgqMPCR2Rauq3LZbN8lc72".aesDecrypt()) ?? ""
public let cantplay = (try? "8SK+FERq/8fHVtMHjO1OubFXtWWwDqvemzrYnEs+F5Y=".aesDecrypt()) ?? ""
public let episodeisplay = (try? "dfAIRY8Cf8cpNuYhM6hxa5j4EIEaAvhUSqkUNgJyiPc=".aesDecrypt()) ?? ""
public let somethingwrong = (try? "Bdx+HFB35ZgYuxVnMnWxYg7W6Zid55vFc5AwCLiDE1r9sa8lnrCyRTGVD2i/zqInf7blRwC+8dtmJa9SiTzkfA==".aesDecrypt()) ?? ""
public let episodeFuture = (try? "dfAIRY8Cf8cpNuYhM6hxazY5fAUzsg2r5xFW0jAkWcw=".aesDecrypt()) ?? ""
public let moiveFuture = (try? "yXFsqDWvISu4ADEBdeTm9ue6tAw2XMDqlQNKCba3EP0=".aesDecrypt()) ?? ""

extension String {
    public func aesEncrypt() throws -> String {
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    public func aesDecrypt() throws -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
    
    func toDictionary() -> LASDictionary? {
        if let data = self.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? LASDictionary
                return result
            } catch { }
        }
        return nil
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: self)
    }
}

extension Data {
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

extension Dictionary {
    
    /// Convert Dictionary to JSON string
    /// - Throws: exception if dictionary cannot be converted to JSON data or when data cannot be converted to UTF8 string
    /// - Returns: JSON string
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}

extension UIViewController {
    private func showAlertConfirm(title: String, message: String? = nil, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okAction()
        }))
        present(alert, animated: true)
    }
    
    func alertPlayback(onReport: @escaping () -> Void) {
        let alert = UIAlertController(title: "Opps!", message: somethingwrong, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
            onReport()
        }))
        present(alert, animated: true)
    }
    
    public func alertNotLink(onReport: @escaping () -> Void) {
        let alert = UIAlertController(title: "Opps!", message: emptylink, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
            onReport()
        }))
        present(alert, animated: true)
    }
    
    func alertReport(message: String? = nil, okAction: @escaping () -> Void) {
        showAlertConfirm(title: "Report", message: message, okAction: okAction)
    }
    
    private func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    public func alertNotice(message: String? = nil) {
        showAlert(title: "Notice", message: message)
    }
    
    public func alertWarning(message: String? = nil) {
        showAlert(title: "Warning", message: message)
    }
    
    public func alertError(message: String? = nil) {
        showAlert(title: "Error", message: message)
    }
}

extension UIColor {
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, thumbnail: UIImage? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async() { [weak self] in
                    self?.image = thumbnail
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, thumbnail: UIImage? = nil) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, thumbnail: thumbnail)
    }
}

extension UIImage {
    static func getImage(_ name: String) -> UIImage? {
        let bundle = ApplicationHelper.shared.bundle()
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

extension UIButton {
    func set(active: Bool) {
        isSelected = active
    }
}

extension UILabel {
    func update(toTime: TimeInterval) {
        var timeFormat: String = "HH:mm:ss"
        if toTime <= 3599 {
            timeFormat = "mm:ss"
        }
        let date = Date(timeIntervalSince1970: toTime)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        formatter.dateFormat = timeFormat
        
        text = formatter.string(from: date)
    }
}

extension UIView {
    func addShadow(color: UIColor = .black, offsetSize: CGSize = .zero, radius: CGFloat = 0, opacity: Float = 1) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offsetSize
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
