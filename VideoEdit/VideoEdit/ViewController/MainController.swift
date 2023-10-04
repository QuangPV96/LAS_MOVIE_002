import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    
    let unSelectColor = 0x999BB0
    let selectColor = 0x655BE8
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Tạo một UIImageView và đặt hình ảnh nền cho nó
        let backgroundImage = UIImageView(image: UIImage(named: "ic_background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        
        // Chèn UIImageView làm background vào UITabBarController
        view.insertSubview(backgroundImage, at: 0)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    private func setColorTabar(item: UITabBarItem){
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x999BB0)]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x655BE8)]
        item.setTitleTextAttributes(normalTextAttributes, for: .normal)
        item.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    private func resizeImage(name: String, color: UIColor, width: Int, height: Int) -> UIImage {
        let originalImage = UIImage(named: name)
        let resizedImage = originalImage?.resized(to: CGSize(width: width, height: height))
        if #available(iOS 13.0, *) {
            let selectedImage = resizedImage?.withTintColor(color).withRenderingMode(.alwaysOriginal)
            return selectedImage!

        } else {
            return resizedImage!
        }
    }

    func initView(){
        let item1 = UITabBarItem(title: "Video", image: resizeImage(name: "ic_video", color: UIColor(hex: unSelectColor), width: 28, height: 19), selectedImage: resizeImage(name: "ic_video", color: UIColor(hex: selectColor), width: 28, height: 19))
        let item2 = UITabBarItem(title: "My Files", image: resizeImage(name: "ic_my_files", color: UIColor(hex: unSelectColor), width: 22, height: 20), selectedImage: resizeImage(name: "ic_my_files", color: UIColor(hex: selectColor), width: 22, height: 20))
        let item3 = UITabBarItem(title: "Setting", image: resizeImage(name: "ic_setting", color: UIColor(hex: unSelectColor), width: 22, height: 24), selectedImage: resizeImage(name: "ic_setting", color: UIColor(hex: selectColor), width: 22, height: 24))
        
        setColorTabar(item: item1)
        setColorTabar(item: item2)
        setColorTabar(item: item3)
        let videoVC = VideoVC()
        videoVC.tabBarItem = item1
        let myFilesVC = MyFilesVC()
        myFilesVC.tabBarItem = item2
        let settingVC = SettingVC()
        settingVC.tabBarItem = item3
        
        self.viewControllers = [videoVC, myFilesVC,settingVC]
        self.delegate = self
        self.selectedIndex = 0
        let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: 0xFFFFFF)
            tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        } else {
        }
    }

}
