import UIKit
import GoogleMobileAds

class AdmobInterstitial: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitial: GADInterstitialAd?
    private var _closeHandler: (() -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - override from supper
    override var canShowAds: Bool {
        if DataCommonModel.shared.admob_inter.isEmpty {
            return false
        }
        
        if !DataCommonModel.shared.isAvailable(.admob, .interstitial) {
            return false
        }
        
        return true
    }
    
    override var isReady: Bool {
        return _interstitial != nil
    }
    
    override func preloadAd(completion: @escaping (Bool) -> Void) {
        self._interstitial = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = DataCommonModel.shared.admob_inter
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            if ad != nil {
                self._interstitial = ad
                self._interstitial?.fullScreenContentDelegate = self
                completion(true)
            }
            else {
                self._interstitial = nil
                if error != nil {
                }
                completion(false)
            }
        }
    }
    
    override func tryToPresent(with closeHandler: @escaping () -> Void) {
        self._closeHandler = nil
        
        guard isReady else {
            closeHandler()
            return
        }
        
        guard let rootController = UIWindow.keyWindow?.topMost else {
            closeHandler()
            return
        }
        
        if let presented = rootController.presentedViewController {
            if presented is HomeVC {
            }
            else {
                self._closeHandler = closeHandler
                self._interstitial?.present(fromRootViewController: presented)
            }
        }
        else {
            self._closeHandler = closeHandler
            self._interstitial?.present(fromRootViewController: rootController)
        }
    }
}

extension AdmobInterstitial: GADFullScreenContentDelegate {
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
    
    public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
