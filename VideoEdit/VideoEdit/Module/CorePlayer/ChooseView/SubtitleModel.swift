//
//  SubtitleModel.swift
//  VideoPlayer
//
//  Created by Quynh Nguyen on 13/06/2022.
//

import Foundation

internal struct VideoIntentModel {
    let sources: [FileSVModel]
    let tracks: [SubtitleModel]
}

internal struct FileSVModel {
    let file: String
    let pixelsize: String
    let title: String
    
    public static func createInstance(_ d: LASDictionary) -> FileSVModel {
        let file = d["file"] as? String
        let pixelsize = d["pixelsize"] as? String
        let title = d["title"] as? String
        return FileSVModel(file: file ?? "", pixelsize: pixelsize ?? "", title: title ?? "")
    }
}

internal enum SubSource {
    case original
    case opensubtitle
    case subscene
}

internal struct SubtitleModel {
    let file: String
    let label: String
    let source: SubSource
    
    enum Format {
        case vtt
        case srt
    }
    
    public static func createInstance(_ d: LASDictionary) -> SubtitleModel {
        let file = d["file"] as? String
        let label = d["label"] as? String
        return SubtitleModel(file: file ?? "", label: label ?? "", source: .original)
    }
}

extension SubtitleModel {
    var webVTT: WebVTT? {
        if let srtText = SubtitleService.shared.getSubtitleText(file) {
            let _parser = WebVTTParser(string: srtText)
            var _webVTT = try? _parser.parse()  // *.vtt
            if _webVTT == nil {
                _webVTT = try? WebVTTParser.parseSubRip(srtText)    // *.srt
            }
            return _webVTT
        }
        return nil
    }
    
    var format: Format {
        if file.lowercased().contains("vtt") {
            return .vtt
        }
        return .srt
    }
}
