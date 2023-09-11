//
//  SettingVC.swift
//  VideoEdit
//
//  Created by Trung Nguyễn on 07/08/2023.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
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
    }
    
    @IBAction func actionFeedback(_ sender: Any) {
    }
    
    @IBAction func actionPrivacy(_ sender: Any) {
    }
    
}
