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
