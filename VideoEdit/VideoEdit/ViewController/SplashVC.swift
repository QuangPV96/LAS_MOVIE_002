//
//  SplashVC.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 08/05/2023.
//

import UIKit
import Lottie
import GoogleMobileAds
import AppTrackingTransparency

class SplashVC: UIViewController {
    
    @IBOutlet weak var viewLoading: UIView!
    
    private let animationLoading = LottieAnimationView(name: "anim_loading")
    private var timer: Timer?
    private var timeLoading = 3
    
    private var requestedTrackingIDFA: Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timerStart()
    }
    
    private func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.countLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func countLoading() {
        if timeLoading == 0 {
            timer?.invalidate()
            timer = nil
            self.navigationController?.pushViewController(MainController(), animated: true)
        } else {
            timeLoading = timeLoading - 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationLoading.contentMode = .scaleAspectFit
        viewLoading.addSubview(animationLoading)
        animationLoading.frame = CGRect(x: 0, y: 0, width: viewLoading.frame.width, height: viewLoading.frame.height)
        DispatchQueue.main.async {
            self.animationLoading.play(fromProgress: 0,
                                       toProgress: 1,
                                       loopMode: LottieLoopMode.loop,
                                       completion: { (finished) in})
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.animationLoading.stop()
    }
}
