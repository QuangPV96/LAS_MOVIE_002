import UIKit
import SafariServices
import StoreKit
import MessageUI

class UtilService: NSObject {
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    static func makeURLImage(_ path: String?) -> URL? {
        guard let _path = path else { return nil }
        return URL(string: "\(prefix_host_image)\(_path)")
    }
    
    static func openURL(_ url: URL, controller: UIViewController) {
        let safari = SFSafariViewController(url: url)
        controller.present(safari, animated: true, completion: nil)
    }
    
    static func openRateApp() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: windowScene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        } else {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func writeEmail(controller: UIViewController) {
        let emailSupport = AppSetting.email
        
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([emailSupport])
            
            controller.present(composeVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Notification", message: "You have not set up an email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            if let popover = alert.popoverPresentationController {
                popover.sourceView = controller.view
                popover.sourceRect = controller.view.bounds
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

extension UtilService: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

