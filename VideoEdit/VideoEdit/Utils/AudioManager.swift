//
//  AudioEngine.swift
//  EqualizerEffect
//
//  Created by 한승진 on 2018. 3. 12..
//  Copyright © 2018년 한승진. All rights reserved.
//

import Foundation
import AVFoundation
import CoreAudio

protocol AudioManagerDelegate: class {
    func audioManager(didStart manager: AudioManager)
    func audioManager(didStop manager: AudioManager)
    func audioManager(didPause manager: AudioManager)
}

class AudioManager {
    weak var delegate: AudioManagerDelegate?
    
    // Variables
    fileprivate let player = AVAudioPlayerNode()
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate var audioFileBuffer: AVAudioPCMBuffer?
    fileprivate var eqNode: AVAudioUnitEQ?
    fileprivate var audioFileTemp: AVAudioFile?
    
    init?(url: URL, frequencies: [Int]) {
        setUpEngine(with: url, frequencies: frequencies)
    }
    
    fileprivate func setUpEngine(with url: URL, frequencies: [Int]) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
            try audioFile.read(into: audioFileBuffer!)
        } catch {
            assertionFailure("failed to load the music. Error: \(error)")
            return
        }
        eqNode = AVAudioUnitEQ(numberOfBands: frequencies.count)
        eqNode!.globalGain = 1
        for i in 0...(eqNode!.bands.count-1) {
            eqNode!.bands[i].frequency  = Float(frequencies[i])
            eqNode!.bands[i].gain       = 0
            eqNode!.bands[i].bypass     = false
            eqNode!.bands[i].filterType = .parametric
        }
        audioEngine.attach(eqNode!)
        audioEngine.attach(player)
        let mixer = audioEngine.mainMixerNode
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let name = "Audio_Temp_Equalizer.caf"
            let outputURL = documentDirectory.appendingPathComponent(name)
            self.deleteFile(outputURL)
            audioFileTemp = try AVAudioFile(forWriting: outputURL, settings: mixer.outputFormat(forBus: 0).settings)
        } catch {
            assertionFailure("failed to load the music. Error: \(error)")
            return
        }
        
        audioEngine.connect(player, to: eqNode!, format: mixer.outputFormat(forBus: 0))
        audioEngine.connect(eqNode!, to: mixer, format: mixer.outputFormat(forBus: 0))
        audioEngine.connect(mixer, to: audioEngine.outputNode, format: nil)
        if let audioFileBuffer = audioFileBuffer {
            player.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
        }
        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: audioEngine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) in
            do {
                try self.audioFileTemp!.write(from: buffer)
            } catch {
                print("Failed to write audio data to file: \(error.localizedDescription)")
            }
        }
    }
    
    func saveAudioFile(){
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let name = "Audio_Temp_Equalizer.caf"
            let outputURL = documentDirectory.appendingPathComponent(name)
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
            audioEngine.mainMixerNode.removeTap(onBus: 0)
            print(outputURL)
        } catch {
            assertionFailure("failed to load the music. Error: \(error)")
            return
        }
    }
    
    func getAudioEngine() -> AVAudioEngine{
        return audioEngine
    }
}


// MARK: State Update
extension AudioManager {
    public func isEngineRunning() -> Bool {
        return audioEngine.isRunning
    }
    
    public func engineStart() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("audioEngine start")
        } catch {
            assertionFailure("failed to audioEngine start. Error: \(error)")
        }
    }
    
    public func play() {
        player.play()
        delegate?.audioManager(didStart: self)
    }
    
    public func stop() {
        player.stop()
        delegate?.audioManager(didStop: self)
    }
    
    public func pause() {
        player.pause()
        delegate?.audioManager(didStart: self)
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
    
}


// MARK: GET, SET
extension AudioManager {
    public func setBypass(_ isOn: Bool) {
        for i in 0...(eqNode!.bands.count-1) {
            eqNode!.bands[i].bypass = isOn
        }
    }
    
    public func setEquailizerOptions(gains: [Float]) {
        guard let eqNode = eqNode else {
            return
        }
        for i in 0...(eqNode.bands.count-1) {
            eqNode.bands[i].gain = gains[i]
        }
    }
    
    public func getEquailizerOptions() -> [Float] {
        guard let eqNode = eqNode else {
            return []
        }
        return eqNode.bands.map { $0.gain }
    }
}
