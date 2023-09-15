//
//  ApplicationHelper.swift
//  LASAdvertising
//
//  Created by KlevinC on 05/03/2022.
//

import UIKit
import StoreKit

public class ApplicationHelper: NSObject {
    // MARK: - using for ads manually
    public static let shared = ApplicationHelper()
    
    internal func bundle() -> Bundle? {
        let bundle = Bundle(for: Self.self)
        return bundle
    }
    
    internal func window() -> UIWindow? {
        // iOS13 or later
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            return windowScene.windows.first
        } else {
            // iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
    
    internal func getTopController(base: UIViewController? = nil) -> UIViewController? {
        let _base = base ?? window()?.rootViewController
        if let nav = _base as? UINavigationController {
            return getTopController(base: nav.visibleViewController)
            
        } else if let tab = _base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopController(base: selected)
            
        } else if let presented = _base?.presentedViewController {
            return getTopController(base: presented)
        }
        return _base
    }
    
    internal func interfaceOrientation() -> UIInterfaceOrientation {
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
    
    internal func openLink(_ link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    public func presentRateApp() {
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
    
    public func presentAlertInstall(appid: String, message: String) {
        guard let root = window()?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.openLink("https://itunes.apple.com/app/id\(appid)")
        }))
        root.present(alert, animated: true, completion: nil)
    }
}
