//
//  ZemPlayerItem.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import AVFoundation

open class ZemPlayerItem: AVPlayerItem {
    
    /// whether content passed through the asset is encrypted and should be decrypted
    public var isEncrypted: Bool = false
    
    public var audioTracks: [ZemPlayerMediaTrack] {
        return tracks(for: .audible)
    }
    
    public var videoTracks: [ZemPlayerMediaTrack] {
        return tracks(for: .visual)
    }
    
    public var captionTracks: [ZemPlayerMediaTrack] {
        return tracks(for: .legible)
    }
    
    deinit {
        
    }
    
    private func convert(with mediaSelectionOption: AVMediaSelectionOption, group: AVMediaSelectionGroup) -> ZemPlayerMediaTrack {
        let title = mediaSelectionOption.displayName
        let language = mediaSelectionOption.extendedLanguageTag ?? "none"
        return ZemPlayerMediaTrack(option: mediaSelectionOption, group: group, name: title, language: language)
    }
    
    private func tracks(for characteristic: AVMediaCharacteristic) -> [ZemPlayerMediaTrack] {
        guard let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) else {
            return []
        }
        let options = group.options
        let tracks = options.map { (option) -> ZemPlayerMediaTrack in
            return convert(with: option, group: group)
        }
        return tracks
    }
    
    public func currentMediaTrack(for characteristic: AVMediaCharacteristic) -> ZemPlayerMediaTrack? {
        
        if let tracks = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic), let currentTrack = currentMediaSelection.selectedMediaOption(in: tracks) {
            return convert(with: currentTrack, group: tracks)
        }
        
        return nil
    }
    
}
