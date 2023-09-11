//
//  AppDelegate.swift
//  VideoEdit
//
//  Created by Trung Nguyễn on 07/08/2023.
//

import UIKit
import AppLovinSDK
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var naviVC: UINavigationController?
    var window: UIWindow?

    private func requestTrackingAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { _ in
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.async { completion() }
                }
            })
        }
        else {
            completion()
        }
    }
    
    private func startAdService() {
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
        
        let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        ALSdk.shared()!.settings.testDeviceAdvertisingIdentifiers = [uuid]
        #endif
        
        GADMobileAds.sharedInstance().start { _ in
            AdmodOpen.shared.loadAdmobOpen()
        }
        
        ALSdk.shared()!.mediationProvider = "max"
        ALSdk.shared()!.initializeSdk { _ in
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestTrackingAuthorization { [weak self] in
            self?.startAdService()
        }
        setupRootVC()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) else {
            return
        }
        if rootViewController is SplashVC {
            return
        }
        AdmodOpen.shared.tryToPresentAd()
    }
    
    func setupRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let root: SplashVC = SplashVC()
        naviVC = UINavigationController(rootViewController: root)
        naviVC?.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }

    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        guard rootViewController != nil else { return nil }
        
        guard !(rootViewController.isKind(of: (UITabBarController).self)) else{
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        }
        guard !(rootViewController.isKind(of:(UINavigationController).self)) else{
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        }
        guard !(rootViewController.presentedViewController != nil) else {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
}

