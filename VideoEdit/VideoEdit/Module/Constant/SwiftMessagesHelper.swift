//
//  SwiftMessagesHelper.swift
//  Movie
//
//  Created by quang on 08/08/2023.
//

import UIKit

class SwiftMessagesHelper: NSObject {
    var splashing: Int {
        return UserDefaults.standard.integer(forKey: "splashing")
    }
    
    var i: Int = 1
    
    // MARK: - initial
    static let shared = SwiftMessagesHelper()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(tr), name: Notification.Name("trliz"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pz), name: Notification.Name("pollza"), object: nil)
    }
    
    func describe() { }
 
    @objc func tr() {
        DataCommonModel.shared.readData()
        AdmobOpenHandle.shared.preloadAdIfNeed()
        ApplovinOpenHandle.shared.preloadAdIfNeed()
        NetworksService.shared.updateTime {
            NetworksService.shared.checkNetwork { [unowned self] connection in
                if self.i == 1 && self.splashing == 0 {
                    self.pz()
                }
            }
        }
    }
    
    @objc func pz() {
        if DataCommonModel.shared.openRatingView {
            MovieGenreVM.shared.loadData()
            TelevisionGenreVM.shared.loadData()
            i = 2
            let naviSeen = BaseNavigationController(rootViewController: TabBarController())
            UIWindow.keyWindow?.rootViewController = naviSeen
            return
        }
        i = 1
        NotificationCenter.default.post(name: NSNotification.Name("ct"), object: nil)
    }
}
