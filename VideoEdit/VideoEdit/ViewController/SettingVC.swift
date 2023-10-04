import UIKit
import StoreKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    @IBAction func actionShare(_ sender: Any) {
        let linkapp = "itms-apps://itunes.apple.com/app/6463258405"
        let noteStr = "Kapcat";
        let url = URL(string: linkapp)!
        let textToShare = [url,noteStr] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func actionFeedback(_ sender: Any) {
        EmailService().compose(controller: self)
    }
    
    @IBAction func actionPrivacy(_ sender: Any) {
        let urlStr = "https://daian3001.github.io/privacy.html"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
    
        }
    }
    
}
