//
//  BaseViewController.swift
//  VideoEdit
//
//  Created by apple on 13/08/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    private let overlayView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    var loadingView: LoadingView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlayView()
    }
    
    private func setupOverlayView() {
        loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: ActivityEx.screenHeight()))
        loadingView.tag = 100
    }
    
    func showLoading() {
        self.view.addSubview(loadingView)
        loadingView.animationView.play()
    }
    
    func hideLoading() {
        loadingView.animationView.stop()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        } else{
            print("No!")
        }
    }
       
}
