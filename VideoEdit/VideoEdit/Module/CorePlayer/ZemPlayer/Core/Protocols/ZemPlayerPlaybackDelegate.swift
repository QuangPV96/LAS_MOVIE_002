//
//  ZemPlayerPlaybackDelegate.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import Foundation
import AVFoundation

public protocol ZemPlayerPlaybackDelegate: AnyObject {
    
    /// Notifies when playback time changes
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    ///     - time: Current time
    func timeDidChange(player: ZemPlayer, to time: CMTime)
    
    /// Whether if playback should begin on specified player
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    ///
    /// - Returns: Boolean to validate if should play
    func playbackShouldBegin(player: ZemPlayer) -> Bool
    
    /// Whether if playback is skipping frames
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackDidJump(player: ZemPlayer)
    
    /// Notifies when player will begin playback
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackWillBegin(player: ZemPlayer)
    
    /// Notifies when playback is ready to play
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackReady(player: ZemPlayer)
    
    /// Notifies when playback did begin
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackDidBegin(player: ZemPlayer)
    
    /// Notifies when player ended playback
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackDidEnd(player: ZemPlayer)
    
    /// Notifies when player starts buffering
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func startBuffering(player: ZemPlayer)
    
    /// Notifies when player ends buffering
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func endBuffering(player: ZemPlayer)
    
    /// Notifies when playback fails with an error
    ///
    /// - Parameters:
    ///     - error: playback error
    func playbackDidFailed(with error: ZemPlayerPlaybackError)
    
    /// Notifies when player will pause playback
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackWillPause(player: ZemPlayer)
    
    /// Notifies when player did pause playback
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    func playbackDidPause(player: ZemPlayer)
    
    /// Notifies when current ZemPlayerItem is ready to play
    ///
    /// - Parameters:
    ///     - player: ZemPlayer being used
    ///     - item: ZemPlayerItem being used
    func playbackItemReady(player: ZemPlayer, item: ZemPlayerItem?)
    
}

public extension ZemPlayerPlaybackDelegate {
    
    func timeDidChange(player: ZemPlayer, to time: CMTime) { }
    
    func playbackShouldBegin(player: ZemPlayer) -> Bool {
        return true
    }
    
    func playbackDidJump(player: ZemPlayer) { }
    
    func playbackWillBegin(player: ZemPlayer) { }
    
    func playbackReady(player: ZemPlayer) { }
    
    func playbackDidBegin(player: ZemPlayer) { }
    
    func playbackDidEnd(player: ZemPlayer) { }
    
    func startBuffering(player: ZemPlayer) { }
    
    func endBuffering(player: ZemPlayer) { }
    
    func playbackDidFailed(with error: ZemPlayerPlaybackError) { }
    
    func playbackWillPause(player: ZemPlayer) { }
    
    func playbackDidPause(player: ZemPlayer) { }
    
    func playbackItemReady(player: ZemPlayer, item: ZemPlayerItem?) { }
}
