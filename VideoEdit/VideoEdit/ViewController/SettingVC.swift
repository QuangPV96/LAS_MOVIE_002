//
//  SettingVC.swift
//  VideoEdit
//
//  Created by Trung Nguyễn on 07/08/2023.
//

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
        let linkapp = "itms-apps://itunes.apple.com/app/6462407114"
        let noteStr = "Cam Translate";
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
        let urlStr = "https://apps.apple.com/us/developer/bac-giang-lgg-garment-corporation/id1510367588"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
    
        }
    }
    
}
