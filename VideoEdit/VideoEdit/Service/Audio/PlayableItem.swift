//
//  PlayableItem.swift
//
//  Created by VancedPlayer on 31/01/2023.
//

import Foundation
import UIKit
import AVFoundation

open class PlayableItem: NSObject {
    var _id: String = ""
    var title: String = ""
    var artist: String = "N/A"
    var album: String = ""
    var imageUrl: String = ""
    var artworkImage: UIImage?
    var pathDownloadInDevice: String = ""
    var fileName: String = ""
    var duration: Double = 0
    var url: URL!;
    
    var isOffline: Bool = false;

    override init() {
        super.init()
    }
    
    init(url: URL) {
        super.init()
        self.url = url;
    }
    
    init(_ dictionary: DDictionary) {
        if let val = dictionary["_id"] as? String { _id = val }
        if let val = dictionary["title"] as? String { title = val }
        if let val = dictionary["artist"] as? String { artist = val }
        if let val = dictionary["album"] as? String { album = val }
        if let val = dictionary["imageUrl"] as? String { imageUrl = val }
        if let val = dictionary["fileName"] as? String { fileName = val }
        if let val = dictionary["pathDownloadInDevice"] as? String {
            pathDownloadInDevice = val
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(pathDownloadInDevice)
            url = fileURL
            let asset = AVAsset(url: url)
            artworkImage = asset.getArtwork()
            duration = CMTimeGetSeconds(asset.duration)
        }
    }
    
    func checkValueEqual(playableItem: PlayableItem) -> Bool {
        if (self._id == playableItem._id && self.title == playableItem.title) {
            return true
        } else {
            return false
        }
    }
    
    func toString() -> [String: Any] {
        return ["_id": _id,
                "title": title,
                "artist": artist,
                "album": album,
                "imageUrl": imageUrl,
                "fileName": fileName,
                "pathDownloadInDevice": pathDownloadInDevice]
    }
    
    static func readFromFileJson() -> [PlayableItem] {
        let string = readString(fileName: NAME_FILE_SAVE)
        if string == nil || string == "" {
            return [PlayableItem]()
        }
        let data: [DDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [PlayableItem]()
        for item in data {
            let model = PlayableItem(item)
            result.append(model)
        }
        return result
    }
    
    static func deleteFile(playableItem: PlayableItem){
        let playableItems = readFromFileJson()
        var playableItemsNew = [PlayableItem]()
        for item in playableItems {
            if !item.checkValueEqual(playableItem: playableItem) {
                playableItemsNew.append(item)
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: playableItemsNew.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_FILE_SAVE)
            }
        } catch {
            print("\(error)")
        }
    }
    
    static func deleteFileEdit(playableItem: PlayableItem){
        let playableItems = readFromFileEditJson()
        var playableItemsNew = [PlayableItem]()
        for item in playableItems {
            if !item.checkValueEqual(playableItem: playableItem) {
                playableItemsNew.append(item)
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: playableItemsNew.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    static func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
            print("convert to json error: \(myJSONError)")
        }
        return nil
    }
    
    static func readFromFileEditJson(fileName: String = NAME_FILE_EDIT_SAVE) -> [PlayableItem] {
        let string = readString(fileName: NAME_FILE_EDIT_SAVE)
        if string == nil || string == "" {
            return [PlayableItem]()
        }
        let data: [DDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [PlayableItem]()
        for item in data {
            let model = PlayableItem(item)
            result.append(model)
        }
        return result
    }
    
    static func convertToPlayableItem(videoModel: VideoModel) -> PlayableItem {
        let playableItem = PlayableItem()
        playableItem.title = videoModel.videoName
        playableItem.url = videoModel.videoPath
        playableItem.duration = videoModel.videoDuration
        playableItem.artworkImage = videoModel.thumbnail
        playableItem.pathDownloadInDevice = videoModel.videoName
        return playableItem
    }
    
}
