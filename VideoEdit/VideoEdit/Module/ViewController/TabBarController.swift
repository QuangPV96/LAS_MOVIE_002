import UIKit
import AVFoundation
import StoreKit

class TabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarView()
        setupViewControllers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.presentRatePopup()
        })
    }
    
    private func presentRatePopup() {
        if !DataCommonModel.shared.isRating { return }
        
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
            SKStoreReviewController.requestReview()
        }
    }
    
    private func setupTabbarView() {
        let backgroundTabbar = UIColor(rgb: 0x0A0909)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundTabbar
            
            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBar.appearance().backgroundColor = backgroundTabbar
            tabBar.backgroundImage = UIImage()
        }
    }
    
    private func setupViewControllers() {
        let home = HomeVC()
        home.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(imgName: "ic-tab-library")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(imgName: "ic-tab-library-active")?.withRenderingMode(.alwaysOriginal))
        home.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let search = SearchVC()
        search.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(imgName: "ic-tab-search")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(imgName: "ic-tab-search-active")?.withRenderingMode(.alwaysOriginal))
        search.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let setting = SettingRootVC()
        setting.tabBarItem = UITabBarItem(title: nil,
                                         image: UIImage(imgName: "ic-tab-setting")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(imgName: "ic-tab-setting-active")?.withRenderingMode(.alwaysOriginal))
        setting.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [BaseNavigationController(rootViewController: home),
                                BaseNavigationController(rootViewController: search),
                                BaseNavigationController(rootViewController: setting)]
    }
    
}
