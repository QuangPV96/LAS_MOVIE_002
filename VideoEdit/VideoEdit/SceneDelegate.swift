import UIKit

@available(iOS 13.0, *)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var naviVC: UINavigationController?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene =  windowScene
        let root: SplashVC = SplashVC()
        naviVC = UINavigationController(rootViewController: root)
        naviVC?.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        self.window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
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

