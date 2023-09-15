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

class SplashVC: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var viewLoading: UIView!
    
    private let animationLoading = LottieAnimationView(name: "anim_loading")
    private var timer: Timer?
    private var timeLoading = 3
    private var splashAd: GADInterstitialAd?
    
    private var isRequestedIDFA: Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(1, forKey: "splashing")
        UserDefaults.standard.synchronize()
        
        if let ss = UserDefaults.standard.string(forKey: "splash_mode"), ss == "admob" {
            self.timeLoading = 15
            self.fetchAd()
        }
        self.timerStart()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ct"), object: nil, queue: .main) { [unowned self] _ in
            self.navigationController?.pushViewController(MainController(), animated: true)
        }
    }
    
    private func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.countLoading)), userInfo: nil, repeats: true)
    }
    
    private func fetchAd() {
        let id = DataCommonModel.shared.admob_inter_splash
        
        if !isRequestedIDFA || id.isEmpty {
            return
        }
        
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            self.timer?.invalidate()
            self.timer = nil
            
            if ad != nil {
                self.splashAd = ad
                self.splashAd?.fullScreenContentDelegate = self
                self.presentAd()
            }
            else {
                self.splashAd = nil
                self.openTabView()
            }
        }
//        qLuqG31hZJOh1H5BLMdJXwkID2cIFSd3NLJcHNr+CaJvb3xUSS8KZetX5DseDtLZ
    }
    
    private func presentAd() {
        guard let root = UIWindow.keyWindow?.rootViewController else { return }
        self.splashAd?.present(fromRootViewController: root)
    }
    
    @objc func countLoading() {
        if timeLoading == 0 {
            timer?.invalidate()
            timer = nil
            self.openTabView()
        } else {
            timeLoading = timeLoading - 1
        }
    }
    
    private func openTabView() {
        UserDefaults.standard.set(0, forKey: "splashing")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("pollza"), object: nil)
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
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        openTabView()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        openTabView()
    }
    
}
