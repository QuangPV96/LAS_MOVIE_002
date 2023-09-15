//
//  ZemPlayerControlsBehaviour.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import UIKit
import Foundation

open class ZemPlayerControlsBehaviour {
    
    /// ZemPlayerControls instance being controlled
    public weak var controls: ZemPlayerControls!
    
    /// Whether controls are bieng displayed
    public var showingControls: Bool = true
    
    /// Whether controls should be hidden when showingControls is true
    public var shouldHideControls: Bool = true
    
    /// Whether controls should be shown when showingControls is false
    public var shouldShowControls: Bool = true
    
    public var shouldAutohide: Bool = false
    
    /// Elapsed time between controls being shown and current time
    public var elapsedTime: TimeInterval = 0
    
    /// Last time when controls were shown
    public var activationTime: TimeInterval = 0
    
    /// At which TimeInterval controls hide automatically
    public var deactivationTimeInterval: TimeInterval = 3
    
    /// Custom deactivation block
    public var deactivationBlock: ((ZemPlayerControls) -> Void)? = nil
    
    /// Custom activation block
    public var activationBlock: ((ZemPlayerControls) -> Void)? = nil
    
    deinit {
        
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///     - controls: ZemPlayerControls to be controlled.
    public init(with controls: ZemPlayerControls) {
        self.controls = controls
    }
    
    /// Update ui based on time
    ///
    /// - Parameters:
    ///     - time: TimeInterval to check whether to update controls.
    open func update(with time: TimeInterval) {
        elapsedTime = time
        if showingControls && shouldHideControls && !controls.handler.player.isBuffering && !controls.handler.isSeeking && controls.handler.isPlaying {
            let timediff = elapsedTime - activationTime
            if timediff >= deactivationTimeInterval {
                hide()
            }
        }
    }
    
    /// Default activation block
    open func defaultActivationBlock() {
        controls.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.controls.alpha = 1
        }
    }
    
    /// Default deactivation block
    open func defaultDeactivationBlock() {
        UIView.animate(withDuration: 0.3, animations: {
            self.controls.alpha = 0
        }) {
            if $0 {
                self.controls.isHidden = true
            }
        }
    }
    
    /// Hide the controls
    open func hide() {
        if shouldAutohide {
            if deactivationBlock != nil {
                deactivationBlock!(controls)
            } else {
                defaultDeactivationBlock()
            }
            showingControls = false
        }
        
    }
    
    /// Show the controls
    open func show() {
        if shouldAutohide {
            if !shouldShowControls {
                return
            }
            activationTime = elapsedTime
            if activationBlock != nil {
                activationBlock!(controls)
            } else {
                defaultActivationBlock()
            }
            showingControls = true
        }
    }
    
}
