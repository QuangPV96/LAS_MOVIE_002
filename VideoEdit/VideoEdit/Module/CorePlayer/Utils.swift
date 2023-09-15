//
//  Utils.swift
//  LASCore
//
//  Created by Quynh Nguyen on 23/06/2022.
//

import UIKit

public enum MediaType: String {
    case movie
    case tv
}

internal func getWindow() -> UIWindow? {
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

internal func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
    let existingView = getWindow()?.viewWithTag(12345)
    if show {
        if existingView != nil {
            return
        }
        let loadingView = makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
        loadingView?.tag = 12345
        getWindow()?.addSubview(loadingView!)
    } else {
        existingView?.removeFromSuperview()
    }
}

internal func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
    let loadingView = UIView(frame: frame)
    loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    if #available(iOS 13.0, *) {
        activityIndicator.style = .large
    }
    else {
        activityIndicator.style = .whiteLarge
    }
    
    activityIndicator.layer.cornerRadius = 6
    activityIndicator.center = loadingView.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .white
    activityIndicator.startAnimating()
    activityIndicator.tag = 100
    
    loadingView.addSubview(activityIndicator)
    
    if !text!.isEmpty {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2,
                             y: activityIndicator.frame.origin.y + 80)
        
        lbl.center = cpoint
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.text = text
        lbl.tag = 1234
        loadingView.addSubview(lbl)
    }
    return loadingView
}
