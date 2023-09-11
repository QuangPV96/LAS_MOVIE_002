//
//  LoadingView.swift
//  RingtoneWallpaper
//
//  Created by Trung Nguyễn on 13/07/2023.
//

import Foundation
import UIKit
import Lottie
class LoadingView: UIView {
    var animationView: LottieAnimationView = LottieAnimationView(frame: CGRect(x: ActivityEx.screenWidth()/2, y: ActivityEx.screenWidth()/2, width: 40, height: 40))

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            settingAnimation(view: view)
        }
    }
    private func settingAnimation(view: UIView) {
        // 2. Start LottieAnimationView with animation name (without extension)
          
          animationView = .init(name: "loading")
          
          animationView.frame = view.bounds
          
          // 3. Set animation content mode
          
          animationView.contentMode = .scaleAspectFit
          
          // 4. Set animation loop mode
          
          animationView.loopMode = .loop
          
          // 5. Adjust animation speed
          
          animationView.animationSpeed = 0.5
          
          view.addSubview(animationView)
    }
}
