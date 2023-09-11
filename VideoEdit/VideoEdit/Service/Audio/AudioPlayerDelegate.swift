//
//  AudioPlayerDelegate.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 01/05/2023.
//

import AVFoundation
public typealias Metadata = [AVMetadataItem]
public typealias TimeRange = (earliest: TimeInterval, latest: TimeInterval)

public protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: AudioManage, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState)
    func audioPlayer(_ audioPlayer: AudioManage, shouldStartPlaying item: PlayableItem) -> Bool
    func audioPlayer(_ audioPlayer: AudioManage, willStartPlaying item: PlayableItem)
    func audioPlayer(_ audioPlayer: AudioManage, didUpdateProgressionTo time: TimeInterval, percentageRead: Float)
    func audioPlayer(_ audioPlayer: AudioManage, didFindDuration duration: TimeInterval, for item: PlayableItem)
    func audioPlayer(_ audioPlayer: AudioManage, didUpdateEmptyMetadataOn item: PlayableItem, withData data: Metadata)
    func audioPlayer(_ audioPlayer: AudioManage, didLoad range: TimeRange, for item: PlayableItem)
}

public extension AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioManage, didChangeStateFrom from: AudioPlayerState,
                     to state: AudioPlayerState) {
    }

    func audioPlayer(_ audioPlayer: AudioManage, shouldStartPlaying item: PlayableItem) -> Bool {
        return true
    }

    func audioPlayer(_ audioPlayer: AudioManage, willStartPlaying item: PlayableItem) {
    }

    func audioPlayer(_ audioPlayer: AudioManage, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
    }

    func audioPlayer(_ audioPlayer: AudioManage, didFindDuration duration: TimeInterval, for item: PlayableItem) {
    }

    func audioPlayer(_ audioPlayer: AudioManage, didUpdateEmptyMetadataOn item: PlayableItem, withData data: Metadata) {
    }

    func audioPlayer(_ audioPlayer: AudioManage, didLoad range: TimeRange, for item: PlayableItem) {
    }
}

