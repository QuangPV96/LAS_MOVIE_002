//
//  ZemPlayerControls.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

open class ZemPlayerControls: UIView {
    private (set) var isLocking: Bool = false {
        didSet {
            let views: [Any] = [backButton, titleLabel, listButton, lockButton, skipBackwardButton, skipForwardButton, playPauseButton, currentTimeLabel, totalTimeLabel, seekbarSlider, languageButton, subtitleButton, airplayContainer, seasonButton]
            
            lockView?.isHidden = !isLocking
            views.forEach { item in
                if let tmp = item as? UIView {
                    tmp.isHidden = isLocking
                }
            }
        }
    }
    
    /// ZemPlayer intance being controlled
    public weak var handler: ZemPlayerView!
    
    /// ZemPlayerControlsBehaviour being used to validate ui
    public var behaviour: ZemPlayerControlsBehaviour!
    
    public var airplayButton: MPVolumeView? = nil
    
    public var onBack: (() -> Void)? = nil
    public var onSubtitle: (() -> Void)? = nil
    public var onList: (() -> Void)? = nil
    public var onSeason: (() -> Void)? = nil
    public var onLanguage: (() -> Void)? = nil
    
    /// ZemPlayerControlsCoordinator instance
    public weak var controlsCoordinator: ZemPlayerControlsCoordinator!
    
    @IBOutlet public weak var backButton: UIButton? = nil
    
    @IBOutlet public weak var titleLabel: UILabel? = nil
    
    @IBOutlet public weak var lockButton: UIButton? = nil
    
    @IBOutlet public weak var subtitleButton: UIButton? = nil
    
    @IBOutlet public weak var listButton: UIButton? = nil
    
    @IBOutlet public weak var seasonButton: UIButton? = nil
    
    @IBOutlet public weak var languageButton: UIButton? = nil
    
    @IBOutlet public weak var lockView: UIView? = nil
    
    /// UIButton instance to represent the play/pause button
    @IBOutlet public weak var playPauseButton: UIButton? = nil
    
    /// Don't use this feature
    /// UIButton instance to represent the fullscreen toggle button
    @IBOutlet public weak var fullscreenButton: UIButton? = nil
    
    /// UIViewContainer to implement the airplay button
    @IBOutlet public weak var airplayContainer: UIView? = nil
    
    /// UIButton instance to represent the skip forward button
    @IBOutlet public weak var skipForwardButton: UIButton? = nil
    
    /// UIButton instance to represent the skip backward button
    @IBOutlet public weak var skipBackwardButton: UIButton? = nil
    
    /// ZemSeekbarSlider instance to represent the seekbar slider
    @IBOutlet public weak var seekbarSlider: UISlider? = nil
    
    /// ZemTimeLabel instance to represent the current time label
    @IBOutlet public weak var currentTimeLabel: UILabel? = nil
    
    /// ZemTimeLabel instance to represent the total time label
    @IBOutlet public weak var totalTimeLabel: UILabel? = nil
    
    /// UIView to be shown when buffering
    @IBOutlet public weak var bufferingView: UIView? = nil
    
    private var wasPlayingBeforeRewinding: Bool = false
    private var wasPlayingBeforeForwarding: Bool = false
    private var wasPlayingBeforeSeeking: Bool = false
    
    /// Skip size in seconds to be used for skipping forward or backwards
    public var skipSize: Double = 30
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZemPlayer.ZPlayerNotificationName.timeChanged.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZemPlayer.ZPlayerNotificationName.play.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZemPlayer.ZPlayerNotificationName.pause.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZemPlayer.ZPlayerNotificationName.buffering.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZemPlayer.ZPlayerNotificationName.endBuffering.notification, object: nil)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        behaviour.hide()
        //controlsCoordinator.showBannerIfNeed()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutInSuperview()
    }
    
    public func layoutInSuperview() {
        if let h = superview as? ZemPlayerControlsCoordinator {
            handler = h.player
            if behaviour == nil {
                behaviour = ZemPlayerControlsBehaviour(with: self)
            }
            prepare()
        }
    }
    
    /// Notifies when time changes
    ///
    /// - Parameters:
    ///     - time: CMTime representation of the current playback time
    open func timeDidChange(toTime time: CMTime) {
        currentTimeLabel?.update(toTime: time.seconds)
        totalTimeLabel?.update(toTime: handler.player.endTime().seconds)
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: time.seconds)
        
        if !(handler.isSeeking || handler.isRewinding || handler.isForwarding) {
            behaviour.update(with: time.seconds)
        }
    }
    
    public func setSeekbarSlider(start startValue: Double, end endValue: Double, at time: Double) {
        let time = time.isNaN ? 0 : time
        let startValue = startValue.isNaN ? 0 : startValue
        let endValue = endValue.isNaN ? 0 : endValue
        
        seekbarSlider?.minimumValue = Float(startValue)
        seekbarSlider?.maximumValue = Float(endValue)
        seekbarSlider?.value = Float(time)
    }
    
    /// Remove coordinator from player
    open func removeFromPlayer() {
        controlsCoordinator.removeFromSuperview()
    }
    
    /// Prepare controls targets and notification listeners
    open func prepare() {
        stretchToEdges()
        
        lockView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unlockScreen)))
        
        backButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        seasonButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        listButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        titleLabel?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        
        backButton?.addTarget(self, action: #selector(back), for: .touchUpInside)
        lockButton?.addTarget(self, action: #selector(lockScreen), for: .touchUpInside)
        languageButton?.addTarget(self, action: #selector(chooseLanguage), for: .touchUpInside)
        subtitleButton?.addTarget(self, action: #selector(subtitle), for: .touchUpInside)
        seasonButton?.addTarget(self, action: #selector(listSeason), for: .touchUpInside)
        listButton?.addTarget(self, action: #selector(listChoose), for: .touchUpInside)
        playPauseButton?.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        fullscreenButton?.addTarget(self, action: #selector(toggleFullscreen), for: .touchUpInside)
        
        skipForwardButton?.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
        skipBackwardButton?.addTarget(self, action: #selector(skipBackward), for: .touchUpInside)
        
        prepareSeekbar()
        
        airplayButton = MPVolumeView()
        airplayButton?.showsVolumeSlider = false
        airplayContainer?.addSubview(airplayButton!)
        airplayContainer?.clipsToBounds = false
        airplayButton?.frame = airplayContainer?.bounds ?? CGRect.zero
        
        for view in airplayButton?.subviews ?? [] {
            if view is UIButton {
                (view as! UIButton).setImage(UIImage.getImage("outline_airplay_white"), for: .normal)
                (view as! UIButton).bounds = .init(x: 0, y: 0, width: 25, height: 25)
            }
        }
        
        seekbarSlider?.setThumbImage(UIImage.getImage("slider-thumb"), for: .normal)
        seekbarSlider?.addTarget(self, action: #selector(playheadChanged(with:)), for: .valueChanged)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpInside)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpOutside)
        seekbarSlider?.addTarget(self, action: #selector(seekingStart), for: .touchDown)
        
        prepareNotificationListener()
        
        isLocking = false
        playPauseButton?.isHidden = true    // default hidden this button to display indicator view
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
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
    
    /// Detect the notfication listener
    private func checkOwnershipOf(object: Any?, completion: @autoclosure ()->()?) {
        guard let ownerPlayer = object as? ZemPlayer else { return }
        if ownerPlayer.isEqual(handler?.player) {
            completion()
        }
    }
    
    /// Prepares the notification observers/listeners
    open func prepareNotificationListener() {
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.timeChanged.notification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            if let time = notification.userInfo?[ZemPlayer.ZPlayerNotificationInfoKey.time.rawValue] as? CMTime {
                self.checkOwnershipOf(object: notification.object, completion: self.timeDidChange(toTime: time))
            }
        }
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.didEnd.notification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: false))
        }
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.play.notification, object: nil, queue: OperationQueue.main) { [weak self]  (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: true))
        }
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.pause.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: false))
        }
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.endBuffering.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.hideBuffering())
        }
        NotificationCenter.default.addObserver(forName: ZemPlayer.ZPlayerNotificationName.buffering.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.showBuffering())
        }
    }
    
    /// Prepare the seekbar values
    open func prepareSeekbar() {
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: handler.player.currentTime().seconds)
    }
    
    /// Show buffering view
    open func showBuffering() {
        bufferingView?.isHidden = false
        if !isLocking {
            playPauseButton?.isHidden = true
        }
    }
    
    /// Hide buffering view
    open func hideBuffering() {
        bufferingView?.isHidden = true
        if !isLocking {
            playPauseButton?.isHidden = false
        }
    }
    
    @objc func unlockScreen() {
        isLocking = false
        behaviour.show()
    }
    
    @IBAction open func back(sender: Any? = nil) {
        onBack?()
    }
    
    @IBAction open func lockScreen(sender: Any? = nil) {
        isLocking = true
        behaviour.show()
    }
    
    @IBAction open func chooseLanguage(sender: Any? = nil) {
        behaviour.hide()
        onLanguage?()
    }
    
    @IBAction open func subtitle(sender: Any? = nil) {
        behaviour.hide()
        onSubtitle?()
    }
    
    @IBAction open func listSeason(sender: Any? = nil) {
        behaviour.hide()
        onSeason?()
    }
    
    @IBAction open func listChoose(sender: Any? = nil) {
        behaviour.hide()
        onList?()
    }
    
    /// Skip forward (n) seconds in time
    @IBAction open func skipForward(sender: Any? = nil) {
        let time = handler.player.currentTime() + CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// Skip backward (n) seconds in time
    @IBAction open func skipBackward(sender: Any? = nil) {
        let time = handler.player.currentTime() - CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// End seeking
    @IBAction func seekingEnd(sender: Any? = nil) {
        handler.isSeeking = false
        let value = Double(seekbarSlider!.value)
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
        behaviour.update(with: time.seconds)
        
        if wasPlayingBeforeSeeking {
            handler.play()
        }
    }
    
    /// Start Seeking
    @IBAction func seekingStart(sender: Any? = nil) {
        wasPlayingBeforeSeeking = handler.isPlaying
        handler.isSeeking = true
        handler.pause()
    }
    
    /// Playhead changed in UISlider
    ///
    /// - Parameters:
    ///     - sender: UISlider that updated
    @IBAction open func playheadChanged(with sender: UISlider) {
        handler.isSeeking = true
        let value = Double(sender.value)
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        currentTimeLabel?.update(toTime: time.seconds)
    }
    
    /// Toggle fullscreen mode
    @IBAction open func toggleFullscreen(sender: Any? = nil) {
        fullscreenButton?.set(active: !handler.isFullscreenModeEnabled)
        handler.setFullscreen(enabled: !handler.isFullscreenModeEnabled)
    }
    
    /// Toggle playback
    @IBAction open func togglePlayback(sender: Any? = nil) {
        if handler.isRewinding || handler.isForwarding {
            handler.player.rate = 1
            playPauseButton?.set(active: true)
            return;
        }
        if handler.isPlaying {
            playPauseButton?.set(active: false)
            handler.pause()
        } else {
            if handler.playbackDelegate?.playbackShouldBegin(player: handler.player) ?? true {
                playPauseButton?.set(active: true)
                handler.play()
            }
        }
    }
    
    private func preparePlaybackButton() {
        if handler.isPlaying {
            playPauseButton?.set(active: true )
        } else {
            playPauseButton?.set(active: false)
        }
    }
    
}
