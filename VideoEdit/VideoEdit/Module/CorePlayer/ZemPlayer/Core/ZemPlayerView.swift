//
//  ZemPlayerView.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation
import AVKit

open class ZemPlayerView: UIView {
    
    deinit {
        player.replaceCurrentItem(with: nil)
    }
    
    /// AVPlayer used in ZemPlayer implementation
    public var player: ZemPlayer!
    
    /// ZemPlayerControls instance being used to display controls
    public var controls: ZemPlayerControls? = nil
    
    /// ZemPlayerRenderingView instance
    public var renderingView: ZemPlayerRenderingView!
    
    /// ZemPlayerPlaybackDelegate instance
    public weak var playbackDelegate: ZemPlayerPlaybackDelegate? = nil
    
    /// ZemPlayer initial container
    private weak var nonFullscreenContainer: UIView!
    
    /// Whether player is prepared
    public var ready: Bool = false
    
    /// Whether it should autoplay when adding a VPlayerItem
    public var autoplay: Bool = true
    
    /// Whether Player is currently playing
    public var isPlaying: Bool = false
    
    /// Whether Player is seeking time
    public var isSeeking: Bool = false
    
    /// Whether Player is presented in Fullscreen
    public var isFullscreenModeEnabled: Bool = false
    
    /// Whether PIP Mode is enabled via pipController
    public var isPipModeEnabled: Bool = false
    
    /// Whether Player is Fast Forwarding
    public var isForwarding: Bool {
        return player.rate > 1.0
    }
    
    /// Whether Player is Rewinding
    public var isRewinding: Bool {
        return player.rate < 0.0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    /// ZemPlayerControls instance to display controls in player, using ZemPlayerGestureRecieverView instance
    /// to handle gestures
    ///
    /// - Parameters:
    ///     - controls: ZemPlayerControls instance used to display controls
    ///     - gestureReciever: Optional gesture reciever view to be used to receive gestures
    public func use(controls: ZemPlayerControls, with gestureReciever: ZemPlayerGestureRecieverView? = nil) {
        self.controls = controls
        let coordinator = ZemPlayerControlsCoordinator()
        coordinator.player = self
        coordinator.controls = controls
        coordinator.gestureReciever = gestureReciever
        controls.controlsCoordinator = coordinator
        
        addSubview(coordinator)
        bringSubviewToFront(coordinator)
    }
    
    /// Update controls to specified time
    ///
    /// - Parameters:
    ///     - time: Time to be updated to
    public func updateControls(toTime time: CMTime) {
        controls?.timeDidChange(toTime: time)
    }
    
    /// Prepares the player to play
    open func prepare() {
        ready = true
        player = ZemPlayer()
        player.handler = self
        player.preparePlayerPlaybackDelegate()
        renderingView = ZemPlayerRenderingView(with: self)
        layout(view: renderingView, into: self)
    }
    
    /// Layout a view within another view stretching to edges
    ///
    /// - Parameters:
    ///     - view: The view to layout.
    ///     - into: The container view.
    open func layout(view: UIView, into: UIView? = nil) {
        guard let into = into else {
            return
        }
        into.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: into.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: into.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: into.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: into.bottomAnchor).isActive = true
    }
    
    /// Enables or disables fullscreen
    ///
    /// - Parameters:
    ///     - enabled: Whether or not to enable
    open func setFullscreen(enabled: Bool) {
        if enabled == isFullscreenModeEnabled {
            return
        }
        if enabled {
            if let window = ApplicationHelper.shared.window() {
                nonFullscreenContainer = superview
                removeFromSuperview()
                layout(view: self, into: window)
            }
        } else {
            removeFromSuperview()
            layout(view: self, into: nonFullscreenContainer)
        }
        
        isFullscreenModeEnabled = enabled
    }
    
    /// Sets the item to be played
    ///
    /// - Parameters:
    ///     - item: The VPlayerItem instance to add to player.
    open func set(item: ZemPlayerItem?) {
        if !ready {
            prepare()
        }
        
        player.replaceCurrentItem(with: item)
        if autoplay && item?.error == nil {
            play()
        }
    }
    
    /// Play
    @IBAction open func play(sender: Any? = nil) {
        if playbackDelegate?.playbackShouldBegin(player: player) ?? true {
            player.play()
            controls?.playPauseButton?.set(active: true)
            isPlaying = true
        }
    }
    
    /// Pause
    @IBAction open func pause(sender: Any? = nil) {
        player.pause()
        controls?.playPauseButton?.set(active: false)
        isPlaying = false
    }
    
    /// Toggle Playback
    @IBAction open func togglePlayback(sender: Any? = nil) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
}
