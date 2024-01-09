import UIKit
import Countly

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var naviVC: UINavigationController?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initCountly()
        getIdAdses()
        DBService.shared.setup()
        ApplovinHandle.shared.awake {
            ApplovinOpenHandle.shared.awake()
        }
        setupRootVC()
        return true
    }

    func setupRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let root: SplashVC = SplashVC()
        naviVC = UINavigationController(rootViewController: root)
        naviVC?.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }
    
    func initCountly(){
        let config: CountlyConfig = CountlyConfig()
        config.appKey = AppSetting.appKey
        config.secretSalt = AppSetting.secretSalt
        config.host = AppSetting.checkingLink
        config.features = [.pushNotifications, .crashReporting]
        config.enableAutomaticViewTracking = true
        config.deviceID = AppSetting.getIDDevice()
#if DEBUG
        config.enableDebug = true
#endif
        Countly.sharedInstance().start(with: config)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) else {
            return
        }
        if rootViewController is SplashVC {
            return
        }
        
        if rootViewController is PlayTrailerVC {
            return
        }
        
        if !AdmobOpenHandle.shared.tryToPresent() {
            ApplovinOpenHandle.shared.tryToPresent()
        }
    }
    
    private func getIdAdses() {
        guard let url = URL(string: AppSetting.list_ads) else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let newData = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: newData, options: .mutableContainers) as? [String:Any] {
                for (key, value) in json {
                    UserDefaults.standard.set(value, forKey: key)
                    UserDefaults.standard.synchronize()
                }
                DBService.shared.saveTimeAdsesLatest()
            }
        }.resume()
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

