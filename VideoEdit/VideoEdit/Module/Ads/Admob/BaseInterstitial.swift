//
//  BaseInterstitial.swift
//  SwiftyAds
//
//  Created by MinhNH on 26/04/2023.
//

import UIKit

class BaseInterstitial: NSObject {
    
    var isReady: Bool {
        return false
    }
    
    var canShowAds: Bool {
        return false
    }
    
    public func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        
    }
    
    public func tryToPresent(with closeHandler: @escaping () -> Void) {
        
    }
}
