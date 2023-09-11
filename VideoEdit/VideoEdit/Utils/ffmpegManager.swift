//
//  FFmpegManager.swift
//  VideoEdit
//
//  Created by apple on 08/08/2023.
//

import Foundation
import mobileffmpeg

protocol FFmpegDelegate{
    func finish()
    func error()
}
class FFmpegManager:NSObject,ExecuteDelegate, StatisticsDelegate, LogDelegate{
    static let shared = FFmpegManager()
    var listAllVideo = [VideoModel]()
    var nameAudioConvert: String = ""
    var outputConvertAudio: URL!
    var delegate: FFmpegDelegate!
    
    func addTextToVideoCmd(videoUrl: String,
                           fontName: String,
                           text: String, name: String, x: String, y:String , fontColor: String) {
        let fileManager = FileManager.default
              let inputFilePath = videoUrl
              if fileManager.fileExists(atPath: inputFilePath) {
                  do {
                      try fileManager.setAttributes([.posixPermissions: 0o777], ofItemAtPath: inputFilePath)
                      print("File exists and permissions set.")
                      
                      // Call your ffmpeg command here using the inputFilePath
                      // Example: executeFFmpegCommand(inputFilePath)
                  } catch {
                      print("Error setting permissions: \(error)")
                  }
              } else {
                  print("File does not exist.")
              }
        var fontType = ".ttf"
        if(fontName == "Brice-Regular" || fontName == "Chillax-Medium") {
            fontType = ".otf"
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        nameAudioConvert = name
        outputConvertAudio = documentDirectory.appendingPathComponent(nameAudioConvert)
        let fontsFolderURL = Bundle.main.url(forResource: fontName, withExtension: fontType)
        let conversionCommand = "-i \(videoUrl) -vf \" drawtext=text='\(text)':x=10:y=10:fontsize=60:fontcolor=\(fontColor):fontfile=\(fontsFolderURL!.path)\" -c:a copy \(outputConvertAudio.path)"
        MobileFFmpeg.executeAsync(conversionCommand, withCallback: self)
    }
    func mergeVideoCmd(videos: [URL]) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        nameAudioConvert = "Audio_\(Date().timeIntervalSince1970).mp4"
        outputConvertAudio = documentDirectory.appendingPathComponent(nameAudioConvert)
        
        let videoFiles = videos.map { url in
            return url.path
        }
        var newVideoFile = [String]()
        videoFiles.forEach { path in
            let newPath = "file '\(path)'"
            newVideoFile.append(newPath)
        }

        let listFilePath = documentDirectory.appendingPathComponent("list.txt").path
        createListFile(videoFiles: newVideoFile, outputPath: listFilePath)
        //-i "concat:input1.mp4|input2.mp4" -c copy output_protocol.mp4
        var input = ""
        videos.forEach { url in
            if(input.isEmpty) {
                input = url.path
            }else {
                input = "\(input)|\(url.path)"
            }
            
        }
        let conversionCommand = "-f concat -safe 0 -i \(listFilePath) -c copy \(outputConvertAudio.path)"
        MobileFFmpeg.executeAsync(conversionCommand, withCallback: self)
    }
    
  private  func createListFile(videoFiles: [String], outputPath: String) {
        let listContent = videoFiles.joined(separator: "\n")
        
        do {
            try listContent.write(toFile: outputPath, atomically: true, encoding: .utf8)
            print("List file created at: \(outputPath)")
        } catch {
            print("Error creating list file: \(error)")
        }
    }
    
    func statisticsCallback(_ statistics: Statistics!) {
        // chỗ này là lấy process khi xử lí file
        DispatchQueue.main.async {
        }
    }
    func executeCallback(_ executionId: Int, _ returnCode: Int32) {
        if (returnCode == RETURN_CODE_SUCCESS) {
            do {
                let pathDownloadInDevice = nameAudioConvert
                var listSongDownload = PlayableItem.readFromFileEditJson()
                
                let playableItem = PlayableItem()
                playableItem._id = "\(Date().timeIntervalSince1970)"
                playableItem.title = nameAudioConvert
                playableItem.pathDownloadInDevice = pathDownloadInDevice
                listSongDownload.append(playableItem)
                let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
                }
            } catch {
            }
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .success, message: "Progress audio success!")
            }
            delegate.finish()

        } else {
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "Progress audio error!")
            }
            delegate.error()
        }
    }
    
    
    func logCallback(_ executionId: Int, _ level: Int32, _ message: String!) {
        
    }
}
