//
//  AudioPlayerState.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 01/05/2023.
//

import UIKit

public enum AudioPlayerState {
    case buffering
    case playing
    case paused
    case stopped
    case waitingForConnection

    /// A boolean value indicating is self = `buffering`.
    var isBuffering: Bool {
        if case .buffering = self {
            return true
        }
        return false
    }

    /// A boolean value indicating is self = `playing`.
    var isPlaying: Bool {
        if case .playing = self {
            return true
        }
        return false
    }

    /// A boolean value indicating is self = `paused`.
    var isPaused: Bool {
        if case .paused = self {
            return true
        }
        return false
    }

    /// A boolean value indicating is self = `stopped`.
    var isStopped: Bool {
        if case .stopped = self {
            return true
        }
        return false
    }

    /// A boolean value indicating is self = `waitingForConnection`.
    var isWaitingForConnection: Bool {
        if case .waitingForConnection = self {
            return true
        }
        return false
    }

}
