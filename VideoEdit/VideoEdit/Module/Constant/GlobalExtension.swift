import UIKit

extension UIFont {
    static func fontReular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Regular", size: size)
    }
    static func fontMedium(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Medium", size: size)
    }
    
    static func fontBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Bold", size: size)
    }
    
    static func fontSemiBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-SemiBold", size: size)
    }
}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    var pathExtension: String {
        return fileURL.pathExtension
    }
    
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
//    var fileName: String {
//        return fileURL.deletingPathExtension().lastPathComponent
//    }
    
    var toJson: MoDictionary? {
        let data = Data(self.utf8)
        
        do {
            // make sure this JSON is in the format we expect
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? MoDictionary
            return json
        } catch let error as NSError {
            print("Convert to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    var toArrayJson: [MoDictionary]? {
        if let data = self.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [MoDictionary]
                return result
            } catch { }
        }
        return nil
    }
}

extension Dictionary {
    func jsonString() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError.make(code: 1002, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
    
    func toData() throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: self)
        return data
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static func createController<T: UIViewController>() -> T {
        return main.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

// MARK: - UIColor
extension UIColor {
    static let background = UIColor(named: "background")!
    static let button_normal = UIColor(named: "button_normal")!
    static let button_selected = UIColor(named: "button_selected")!
    static let shadow = UIColor(named: "shadow")!
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        // MARK: - iOS13 or later
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            return windowScene.windows.first
        }
        else {
            // MARK: - iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
    
    var topMost: UIViewController? {
        return UIWindow.keyWindow?.rootViewController
    }
}

extension UIApplication {
    static func findTopController(root: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return findTopController(root: nav.visibleViewController)
        }
        else if let tab = root as? UITabBarController, let selected = tab.selectedViewController {
            return findTopController(root: selected)
        }
        else if let presented = root?.presentedViewController {
            return findTopController(root: presented)
        }
        return root
    }
    
    static  func orientation() -> UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return .unknown
            }
            return windowScene.interfaceOrientation
        }
        else {
            return UIApplication.shared.statusBarOrientation
        }
    }
}

extension UIApplication {
    class func getTopController(base: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopController(base: presented)
        }
        return base
    }
}

extension UIView {
    func roundTopLeftRight(radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func setImageBackground() {
        backgroundColor = .shadow
    }
}

extension UIButton {
    func addBlurEffect() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}

extension UIImage {
    class func original(_ name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
    
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time) % 60
        let hours = (time / 60)
        return String(format: "%0.2d:%0.2d:00",hours,minutes)
    }
}

extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension String {
    func trimming() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func registerItem<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
}

extension UICollectionReusableView {
    static var cellID: String {
        return String(describing: self)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UILabel {
    func labelTwoColor(title: String, colorTitle: UIColor, fontTitle: UIFont? = nil, detail: String, colorDetail: UIColor, fontDetail: UIFont? = nil) {
        let ss = "\(title)\(detail)"
        let attributed = NSMutableAttributedString(string: ss)
        
        // title
        let range1 = NSString(string: ss).range(of: title)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTitle, range: range1)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontTitle ?? UIFont.fontReular(12))!, range: range1)
        
        // detail
        let range2 = NSString(string: ss).range(of: detail)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorDetail, range: range2)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontDetail ?? UIFont.fontReular(12))!, range: range2)
        
        self.attributedText = attributed
    }
}

extension UITableView {
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
            
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
            
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
}
extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}

extension UITableView {
    func registerItem<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func registerItemNib<T: UITableViewCell>(cell: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let cell = dequeueReusableCell(withIdentifier: T.identifier) as! T
        return cell
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIImage {
    convenience init?(imgName name: String) {
        self.init(named: name, in: Bundle.current, compatibleWith: nil)
    }
}
