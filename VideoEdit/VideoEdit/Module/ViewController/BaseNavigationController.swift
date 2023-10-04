import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - property
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - outlet
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
}
