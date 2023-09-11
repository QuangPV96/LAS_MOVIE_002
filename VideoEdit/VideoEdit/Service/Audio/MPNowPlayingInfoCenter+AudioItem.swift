import MediaPlayer

extension MPNowPlayingInfoCenter {
    func updateNow(with item: PlayableItem, duration: TimeInterval?, progression: TimeInterval?, playbackRate: Float) {
        var info = [String: Any]()
        if item.title != ""  {
            info[MPMediaItemPropertyTitle] = item.title
        }
        if item.artist != "" {
            info[MPMediaItemPropertyArtist] = item.artist
        }
        if item.album != "" {
            info[MPMediaItemPropertyAlbumTitle] = item.album
        }
        if let artwork = item.artworkImage {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { _ in artwork }
        }
        if let duration = duration {
            info[MPMediaItemPropertyPlaybackDuration] = duration
        }
        if let progression = progression {
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progression
        }
        info[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate

        nowPlayingInfo = info
    }
}
