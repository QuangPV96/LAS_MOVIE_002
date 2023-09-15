import Foundation

public struct WebVTT {
    public struct Cue {
        public let timing: Timing
        public let text: String
    }
    
    // Native timing in WebVTT. Measured in milliseconds.
    public struct Timing {
        public let start: Int
        public let end: Int
    }
    
    public let cues: [Cue]
    
    public init(cues: [Cue]) {
        self.cues = cues
    }
}

public extension WebVTT {
    func searchSubtitles(time: Int) -> String? {
        guard let firstSub = cues.filter({ c in
            return c.timing.start <= time && time <= c.timing.end
        }).first else {
            return nil
        }
        
        return firstSub.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public extension WebVTT.Timing {
    var duration: Int { return end - start }
}

// Converted times for convenience
public extension WebVTT.Cue {
    var timeStart: TimeInterval { return TimeInterval(timing.start) / 1000 }
    var timeEnd: TimeInterval { return TimeInterval(timing.end) / 1000 }
    var duration: TimeInterval { return TimeInterval(timing.duration) / 1000 }
}
