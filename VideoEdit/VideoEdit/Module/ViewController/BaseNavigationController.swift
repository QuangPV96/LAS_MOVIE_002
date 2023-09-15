//
//  BaseNavigationController.swift
//  SwiftyAds
//
//  Created by MinhNH on 09/04/2023.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - property
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - outlet
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
}
