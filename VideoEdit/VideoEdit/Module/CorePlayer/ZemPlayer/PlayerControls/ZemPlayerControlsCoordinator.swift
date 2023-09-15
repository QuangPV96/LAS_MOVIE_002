//
//  ZemPlayerControlsCoordinator.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

open class ZemPlayerControlsCoordinator: UIView, ZemPlayerGestureRecieverViewDelegate {
    
    /// ZemPlayer instance being used
    weak var player: ZemPlayerView!
    
    /// ZemPlayerControls instance being used
    weak public var controls: ZemPlayerControls!
    
    /// ZemPlayerGestureRecieverView instance being used
    public var gestureReciever: ZemPlayerGestureRecieverView!
    
    deinit {
        
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        stretchToEdges()
    }
    
    public func configureView() {
        if controls != nil {
            addSubview(controls)
        }
        if gestureReciever == nil {
            gestureReciever = ZemPlayerGestureRecieverView()
            gestureReciever.delegate = self
            addSubview(gestureReciever)
            sendSubviewToBack(gestureReciever)
        }
        stretchToEdges()
    }
    
    public func stretchToEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    open func hideBannerIfNeed() {

    }
    
    open func showBannerIfNeed() {

    }
    
    /// Notifies when pinch was recognized
    ///
    /// - Parameters:
    ///     - scale: CGFloat value
    open func didPinch(with scale: CGFloat) {
        
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    open func didTap(at point: CGPoint) {
        if controls.behaviour.showingControls {
            controls.behaviour.hide()
            //showBannerIfNeed()
            
        } else {
            controls.behaviour.show()
            //hideBannerIfNeed()
        }
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    open func didDoubleTap(at point: CGPoint) {
        if controls.isLocking {
            return
        }
        
        if player.renderingView.playerLayer.videoGravity == AVLayerVideoGravity.resizeAspect {
            player.renderingView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        } else {
            player.renderingView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        }
    }
    
    /// Notifies when pan was recognized
    ///
    /// - Parameters:
    ///     - translation: translation of pan in CGPoint representation
    ///     - at: initial point recognized
    open func didPan(with translation: CGPoint, initially at: CGPoint) {
        
    }
    
}
