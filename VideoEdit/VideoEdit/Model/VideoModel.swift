//
//  VideoModel.swift
//  VideoEdit
//
//  Created by apple on 08/08/2023.
//

import Foundation
import UIKit
class VideoModel: NSObject {
    var thumbnail: UIImage!
    var videoSize: String = ""
    var videoDuration: Double = 0
    var videoName: String = ""
    var videoPath: URL!
    var isNotSelect: Bool = true
    
    override init() {
        
    }
    init(_ thumbnail: UIImage, videoSize: String, videoDuration: Double, videoName: String, videoPath: URL) {
        self.thumbnail = thumbnail
        self.videoSize = videoSize
        self.videoDuration = videoDuration
        self.videoName = videoName
        self.videoPath = videoPath
    }
    
}
