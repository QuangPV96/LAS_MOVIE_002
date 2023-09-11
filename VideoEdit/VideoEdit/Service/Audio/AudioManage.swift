//
//  AudioManage.swift
//  EnglishSocial
//
//  Created by VancedPlayer on 1/3/18.
//  Copyright © 2018 N2GU. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import MediaPlayer

final public class AudioManage: NSObject {
    
    public struct Notifications {
        static let willStartPlayingItem = "\(String(describing: Bundle.main.bundleIdentifier)).willStartPlayingItem";
        static let didChangeState = "\(String(describing: Bundle.main.bundleIdentifier)).didChangeState";
        static let didProgressTo = "\(String(describing: Bundle.main.bundleIdentifier)).didProgressTo";
    }
    
    private var timeObserver: Any?
    
    fileprivate var player = AVPlayer()
    public weak var delegate: AudioPlayerDelegate?
    static let shared:AudioManage = AudioManage()
     let audioEngine = AVAudioEngine()
     var audioFileBuffer: AVAudioPCMBuffer?
     var EQNode: AVAudioUnitEQ?
    var playerLayer = AVPlayerLayer()
    public internal(set) var listMusic: [PlayableItem] = [PlayableItem]()
    
    public internal(set) var currentItem: PlayableItem? {
        didSet {
            if let currentItem = currentItem {
                play(url: currentItem.url!)
                updateNowPlayingInfoCenter()
                delegate?.audioPlayer(self, willStartPlaying: currentItem)
                NotificationCenter.default.post(name: Notification.Name(rawValue: AudioManage.Notifications.willStartPlayingItem), object: currentItem)
            } else {
                stop()
            }
        }
    }
    
    public internal(set) var state = AudioPlayerState.stopped {
        didSet {
            updateNowPlayingInfoCenter()

            if state != oldValue {
                delegate?.audioPlayer(self, didChangeStateFrom: oldValue, to: state)
                NotificationCenter.default.post(name: Notification.Name(rawValue: AudioManage.Notifications.didChangeState), object: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.updateNowPlayingInfoCenter()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.updateNowPlayingInfoCenter()
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: AudioManage.Notifications.didChangeState), object: nil)
        }
    }
    
    public func play(items: [PlayableItem], startAtIndex index: Int = 0) {
        if !items.isEmpty {
            listMusic = items
            currentItem = listMusic[index]
        } else {
            stop()
        }
    }
    
    func next(){
        if listMusic.firstIndex(of: currentItem!) == (listMusic.count - 1) {
            state = .stopped
            return
        } else {
            currentItem = listMusic[listMusic.firstIndex(of: currentItem!)! + 1]
        }
    }
    
    func previous(){
        if listMusic.firstIndex(of: currentItem!) == 0 {
            state = .stopped
            return
        } else {
            currentItem = listMusic[listMusic.firstIndex(of: currentItem!)! - 1]
        }
    }
    
    // public
    func stop() {
        pause()
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
        timeObserver = nil

        state = .stopped
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        _ = try? AVAudioSession.sharedInstance().setActive(false)
    }
    func pause() {
        state = .paused
        player.pause()
    }

    func resume() {
        state = .playing
        player.play()
    }
    
    func play(url: URL?) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        stop()
        if let url_1 = url {
            let playerItem = CachingPlayerItem(url: url_1)
            playerItem.delegate = self
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
                //self!.next()
                self!.state = .stopped
                NotificationCenter.default.post(name: Notification.Name(rawValue: AudioManage.Notifications.didChangeState), object: nil)
                print("")
            }
            player.volume = 0.5
            if #available(iOS 10.0, *) {
                player.automaticallyWaitsToMinimizeStalling = false
            } else {
            }
            player.play()
            state = .playing
            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 2), queue: .main) { time in
                if let currentItemProgression = time.ap_timeIntervalValue, let item = self.player.currentItem,
                    item.status == .readyToPlay {
                    let itemDuration = self.currentItemDuration ?? 0
                    let percentage = (itemDuration > 0 ? Float(currentItemProgression / itemDuration) * 100 : 0)
                    self.delegate?.audioPlayer(self, didUpdateProgressionTo: currentItemProgression, percentageRead: percentage)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: AudioManage.Notifications.didProgressTo), object: nil)
                }

            }
        }
    }
    
    func isPlaying() -> Bool {
        return player.rate == 1.0
    }
    
    func updateNowPlayingInfoCenter() {
        if let item = currentItem {
            MPNowPlayingInfoCenter.default().updateNow(
                with: item,
                duration: currentItemDuration,
                progression: currentItemProgression,
                playbackRate: 1.0)
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        }
    }
}


extension AudioManage: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
    }
    
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print(error)
    }
    
    public var currentItemProgression: TimeInterval? {
        return player.currentItem?.currentTime().ap_timeIntervalValue
    }

    public var currentItemDuration: TimeInterval? {
        return player.currentItem?.duration.ap_timeIntervalValue
    }
    
    public func seek(to time: TimeInterval,
                                toleranceBefore: CMTime = CMTime.positiveInfinity,
                                toleranceAfter: CMTime = CMTime.positiveInfinity,
              completionHandler: ((Bool) -> Void)?) {
        guard let completionHandler = completionHandler else {
            self.player.seek(to: CMTime(timeInterval: time), toleranceBefore: toleranceBefore,
                         toleranceAfter: toleranceAfter)
            self.updateNowPlayingInfoCenter()
            return
        }
        guard self.player.currentItem?.status == .readyToPlay else {
            completionHandler(false)
            return
        }
        self.player.seek(to: CMTime(timeInterval: time), toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter,
                     completionHandler: { [weak self] finished in
                        completionHandler(finished)
                        self!.updateNowPlayingInfoCenter()
        })
    }
}
