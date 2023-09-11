//
//  OptiVideoEditor.swift
//  LAS_SAMPLE_009
//
//  Created by apple on 23/05/2023.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit
import Photos
import mobileffmpeg
class OptiVideoEditor: NSObject {
    //MARK: crop the video which you select portion
    //MARK: crop the video which you select portion

    func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, success: @escaping ((PlayableItem) -> Void), failure: @escaping ((String?) -> Void)) {
        let asset = AVAsset(url: sourceURL)
        _ = Float(asset.duration.value) / Float(asset.duration.timescale)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = "Trim_\(Date().timeIntervalSince1970).\(sourceURL.pathExtension)"
        let outputURL = documentDirectory.appendingPathComponent(name)
        self.deleteFile(outputURL)
        
        //export the video to as per your requirement conversion
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: asset.duration.timescale),end: CMTime(seconds: endTime, preferredTimescale: asset.duration.timescale))
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .completed:
                let playableItem = PlayableItem()
                do {
                    let pathDownloadInDevice = name
                    var listSongDownload = PlayableItem.readFromFileEditJson()
                    
                    playableItem._id = "\(Date().timeIntervalSince1970)"
                    playableItem.title = name
                    playableItem.pathDownloadInDevice = pathDownloadInDevice
                    playableItem.url = outputURL
                    listSongDownload.append(playableItem)
                    let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                    if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        writeString(aString: jsonString, fileName: NAME_FILE_SAVE)
                    }
                } catch {
                    print("\(error)")
                }
                success(playableItem)
            case .failed:
                failure(exportSession.error?.localizedDescription)
                
            case .cancelled:
                failure(exportSession.error?.localizedDescription)
                
            default:
                failure(exportSession.error?.localizedDescription)
            }
        })
    }
   
    func createOutPutFile(name: String)-> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentDirectory.appendingPathComponent(name)
        return outputURL
    }
    
    func extraVideoToAudio(videoUrl: URL, isTemp: Bool, success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        let composition = AVMutableComposition()
        do {
            let asset = AVURLAsset(url: videoUrl)
            guard let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else { return }
            guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid) else { return }
            try audioCompositionTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: CMTime.zero)
        } catch {
            print(error)
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        var name = "Audio_\(Date().timeIntervalSince1970).m4a"
        if isTemp == true {
            name = "Audio_Temp.m4a"
        } else {
            name = "Audio_\(Date().timeIntervalSince1970).m4a"
        }
        let outputURL = documentDirectory.appendingPathComponent(name)
        self.deleteFile(outputURL)
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = outputURL
        
        exportSession.exportAsynchronously {
            guard case exportSession.status = AVAssetExportSession.Status.completed else { return }
            
            DispatchQueue.main.async {
                guard let outputURL = exportSession.outputURL else {
                    failure("")
                    return
                }
                if isTemp == false {
                    do {
                        let pathDownloadInDevice = name
                        var listSongDownload = PlayableItem.readFromFileEditJson()
                        
                        let playableItem = PlayableItem()
                        playableItem._id = "\(Date().timeIntervalSince1970)"
                        playableItem.title = name
                        playableItem.pathDownloadInDevice = pathDownloadInDevice
                        listSongDownload.append(playableItem)
                        let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
                        }
                    } catch {
                        print("\(error)")
                    }
                }
                
                success(outputURL)
            }
        }
    }
    
    func writeFileAudioEqualizer(audioEngine: AVAudioEngine, success: @escaping ((URL) -> Void)){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = "Audio_Temp_Equalizer.caf"
        let outputURL = documentDirectory.appendingPathComponent(name)
        self.deleteFile(outputURL)
        do {
            let audioFile = try AVAudioFile(forWriting: outputURL, settings: audioEngine.mainMixerNode.outputFormat(forBus: 0).settings)
            try audioEngine.start()
            audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: audioEngine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
                print(buffer)
                try? audioFile.write(from: buffer)
            }
            audioEngine.mainMixerNode.removeTap(onBus: 0)
            audioEngine.stop()

            let pathDownloadInDevice = name
            var listSongDownload = PlayableItem.readFromFileEditJson()

            let playableItem = PlayableItem()
            playableItem._id = "\(Date().timeIntervalSince1970)"
            playableItem.title = name
            playableItem.pathDownloadInDevice = pathDownloadInDevice
            listSongDownload.append(playableItem)
            let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
            }
            
            success(outputURL)
        } catch {
            print("\(error)")
        }
        
    }
    
    func mergeVideoWithAudio(videoUrl: URL, audioUrl: URL, success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        let aVideoAsset: AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset: AVAsset = AVAsset(url: audioUrl)
        let mixComposition: AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack: [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack: [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        
        if let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid), let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            mutableCompositionVideoTrack.append(videoTrack)
            mutableCompositionAudioTrack.append(audioTrack)
            
            if let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: .video).first, let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: .audio).first {
                do {
                    try mutableCompositionVideoTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)
                    try mutableCompositionAudioTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)
                    videoTrack.preferredTransform = aVideoAssetTrack.preferredTransform
                    
                } catch{
                    failure(error.localizedDescription)
                }
                
                totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero,duration: aVideoAssetTrack.timeRange.duration)
            }
        }
        
        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mutableVideoComposition.renderSize = CGSize(width: 1920, height: 1080) //(720, 480), (1920,1080)
        
        //Create Directory path for Save
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var outputURL = documentDirectory.appendingPathComponent("MergeVideowithAudio")
        do {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(outputURL.lastPathComponent).m4v")
        }catch let error {
            failure(error.localizedDescription)
        }
        
        //Remove existing file
        self.deleteFile(outputURL)
        
        //export the video to as per your requirement conversion
        if let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) {
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true
            
            /// try to export the file and handle the status cases
            exportSession.exportAsynchronously(completionHandler: {
                switch exportSession.status {
                case .completed :
                    success(outputURL)
                case .failed:
                    if let _error = exportSession.error?.localizedDescription {
                        failure(_error)
                    }
                case .cancelled:
                    if let _error = exportSession.error?.localizedDescription {
                        failure(_error)
                    }
                default:
                    if let _error = exportSession.error?.localizedDescription {
                        failure(_error)
                    }
                }
            })
        } else {
            failure("video export session failed")
        }
    }
    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    //MARK : get album inside photos library
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self?.createAlbum(withTitle: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }
    //MARK : Create album inside photos library
    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var placeholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    UserDefaults.standard.set(true, forKey: "AlbumCreated1")
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }
                completionHandler(album)
            })
        }
    }
    //MARK : save video inside photos library same album name
    func save(videoUrl: URL, toAlbum titled: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbum(title: titled) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
                    let assets = assetRequest?.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    completionHandler(success, error)
                })
            }
        }
    }
}
