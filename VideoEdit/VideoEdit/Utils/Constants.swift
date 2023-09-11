//
//  Constants.swift
//  RingtoneWallpaper
//
//  Created by Trung Nguyễn on 12/07/2023.
//

import Foundation
import UIKit
import AVFoundation
import Photos

let TYPE_NEW = "New"
let POPULAR = "Popular"
let FLOWERS = "Flowers"
let CALENDARS = "Calendars"
let QUOTES = "Quotes"
let MISC = "Girls"
let Zen = "Zen"
let Masterpieces = "Masterpieces"
let MINIMAL = "Minimal"
let Abstract = "Abstract"
let Cartoon = "Cartoon"
let SciFi = "Sci-Fi"
let Animals = "Animals"
let Sports = "Sports"
let Nature = "Nature"
let Cities = "Cities"
let M3D = "3D"
let Holidays = "Holidays"

public let NAME_FILE_SAVE = "list_song_local.json"
public let NAME_FILE_EDIT_SAVE = "list_song_edit_local.json"

#if DEBUG
    public let admod_banner = "ca-app-pub-3940256099942544/2934735716"
    public let admod_interstital = "ca-app-pub-3940256099942544/4411468910"
    public let admod_interstital_splash = "ca-app-pub-3940256099942544/4411468910"
    public let admod_reward = ""
    public let admod_reward_interstital = ""
    public let admod_small_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_medium_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_manual_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_app_open = "ca-app-pub-3940256099942544/3419835294"

    public let max_banner = ""
    public let max_interstital = ""
    public let max_splash = ""
    public let max_reward = ""
    public let max_small_native = ""
    public let max_medium_native = ""
    public let max_manual_native = ""
    public let max_app_open = ""
#else
    public let admod_banner = "ca-app-pub-2299291161271404/8272939431"
    public let admod_interstital = "ca-app-pub-2299291161271404/2214512133"
    public let admod_interstital_splash = "ca-app-pub-2299291161271404/9398318841"
    public let admod_reward = "ca-app-pub-2299291161271404/5192029261"
    public let admod_reward_interstital = "ca-app-pub-2299291161271404/6959857763"
    public let admod_small_native = "ca-app-pub-2299291161271404/9060203653"
    public let admod_medium_native = "ca-app-pub-2299291161271404/5646776094"
    public let admod_manual_native = "ca-app-pub-2299291161271404/5781387903"
    public let admod_app_open = "ca-app-pub-2299291161271404/1975920555"

    public let max_banner = "cfdbab700207037d"
    public let max_interstital = "f1e02fbbb4a8f5e1"
    public let max_splash = "398eb768f34ae103"
    public let max_reward = "1a327f075529f885"
    public let max_small_native = "12bab982eaa84646"
    public let max_medium_native = "9be43f9dca78a291"
    public let max_manual_native = "1dd70b411dd4798f"
    public let max_app_open = "35fa72c23c26a56e"
#endif


func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
typealias DDictionary = [String: Any]
public let clientId = "penbhtwyvbl5002pg14o2soh1vjc0qnv"
public let clientSecret = "hjBWL6buEAyK0SK0s8kbh7Cm7MSMAeX6"
protocol SelectCell {
    func selectCell(index: Int)
    func selectMoreCell(index: Int)
}
class Constants {
   static func saveVideoAsMP4ToDocumentDirectory(inputVideoURL: URL, completion: ((URL,String) -> Void)!) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let devicePath = "\(Date().timeIntervalSince1970)"
        let outputURL = documentsDirectory.appendingPathComponent("\(devicePath).mp4")
        
        let asset = AVAsset(url: inputVideoURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            return nil
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(outputURL,devicePath)
                print("Video converted and saved as MP4: \(outputURL)")
            } else if exportSession.status == .failed {
                print("Video conversion failed: \(exportSession.error?.localizedDescription ?? "")")
            }
        }
        return outputURL
    }

       static func format(duration: TimeInterval) -> String {
           let formatter = DateComponentsFormatter()
           formatter.zeroFormattingBehavior = .pad
           
           if duration >= 3600 {
               formatter.allowedUnits = [.hour, .minute, .second];
           } else {
               formatter.allowedUnits = [.minute, .second];
           }
           let value = formatter.string(from: duration) ?? "";
           return value
       }

    static func sizePerKB(url: URL?) -> String {
        guard let filePath = url?.path else {
            return "0KB"
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                let fileSizeKB = size.doubleValue / 1024.0 // Chia cho 1024 để chuyển đổi sang KB
                let formattedSize = String(format: "%.2fKB", fileSizeKB)
                return formattedSize

            }
        } catch {
            print("Error: \(error)")
        }
        return "0KB"
    }
    
    static func getVideoInfo(from asset: PHAsset,
                             avAsset: AVURLAsset,
                             videoURL: URL,
                             completion: (([VideoModel]) -> Void)!) {
        let fileSizeInMBString = Constants.sizePerKB(url: videoURL)
         let imageManager = PHImageManager.default()
         let requestOptions = PHImageRequestOptions()
        var listVideo: [VideoModel] = []
        let videoDuration = avAsset.duration
        let durationInSeconds = CMTimeGetSeconds(videoDuration)
         requestOptions.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) {(image, _) in
             if let thumbnail = image {
                 let videoName = asset.value(forKey: "filename") as? String ?? "Unknown"
                
                 let model = VideoModel(thumbnail, videoSize: fileSizeInMBString, videoDuration: durationInSeconds, videoName: videoName, videoPath: videoURL)
                 listVideo.append(model)
                 completion(listVideo)
             }
         }
     }
}

public func readString(fileName: String) -> String? {
    do {
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            let savedText = try String(contentsOf: fileURL)
            return savedText
        }
        return nil
    } catch {
        return nil
    }
}

public func writeString(aString: String, fileName: String) {
    do {
        
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            try aString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    } catch {
        print("\(error)")
    }
}
