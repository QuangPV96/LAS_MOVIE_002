import UIKit
import AVFoundation

class PlayVC: UIViewController {
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lbProgress: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var viewPlayer: PView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblToolbar: UILabel!
    
    var playableItem = PlayableItem()
    var isSeeking: Bool = false
    var startAtIndex = 0
    var playableList = [PlayableItem]()
    var timer: Timer?
       var counter = 0
    // Tạo một view mới
            let customView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblToolbar.text = playableItem.title
        AudioManage.shared.play(items: playableList, startAtIndex: startAtIndex)
        self.lbProgress.text = Constants.format(duration: 0);
        self.lbDuration.text = Constants.format(duration: AudioManage.shared.currentItemDuration ?? 0);
        if AudioManage.shared.currentItem!.artworkImage != nil {
            self.imgThumb.image = AudioManage.shared.currentItem!.artworkImage!
        } else {
            self.imgThumb.image = UIImage(named: "ic_temp_home")
        }
        self.sliderBar.maximumValue = Float(AudioManage.shared.currentItemDuration ?? 0)
        self.sliderBar.value = Float(AudioManage.shared.currentItemProgression ?? 0)
        self.btnPlay.setImage(UIImage(named: "ic_pause"), for: .normal)
        self.sliderBar.addTarget(self, action: #selector(handleSliderChangeValue(sender:event:)), for: .allEvents)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(timer != nil){
            timer?.invalidate() // Hủy timer khi controller bị giải phóng
            timer = nil
        }
        print("212345678")
        AudioManage.shared.stop()
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
    }

    @objc func updateCounter() {
           counter += 1
           print("Counter: \(counter)")
           
       }
    @objc func handleSliderChangeValue(sender: AnyObject, event: UIEvent) {
        guard let handleEvent = event.allTouches?.first else { return }
        switch handleEvent.phase {
        case .began:
            isSeeking = true
            break
        case .ended:
            AudioManage.shared.seek(to: Double(self.sliderBar.value)) { status in
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.isSeeking = false
            }
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if(AudioManage.shared.currentItem != nil) {
            self.lbProgress.text = Constants.format(duration: AudioManage.shared.currentItemProgression ?? 0);
            self.lbDuration.text = Constants.format(duration: AudioManage.shared.currentItemDuration ?? 0);
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidChangeState), name: Notification.Name(rawValue: AudioManage.Notifications.didChangeState), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPlaybackProgression), name: Notification.Name(rawValue: AudioManage.Notifications.didProgressTo), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerWillStartPlaying), name: Notification.Name(rawValue: AudioManage.Notifications.willStartPlayingItem), object: nil);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioManage.shared.playerLayer.frame = CGRect(x: 0, y: 0, width: self.viewPlayer.bounds.size.width, height: self.viewPlayer.bounds.size.height)
        self.viewPlayer.layer.addSublayer(AudioManage.shared.playerLayer)
    }
    
    @objc func audioPlayerWillStartPlaying(_ notification: Notification) {
        if(AudioManage.shared.currentItem == nil) {
            return;
        }
        
        if AudioManage.shared.currentItem!.artworkImage != nil {
            self.imgThumb.image = AudioManage.shared.currentItem!.artworkImage!
        } else {
            self.imgThumb.image = UIImage(named: "ic_default")
        }
        
        self.lbProgress.text = Constants.format(duration: AudioManage.shared.currentItemProgression ?? 0)
        self.lbDuration.text = Constants.format(duration: AudioManage.shared.currentItemDuration ?? 0)
        self.sliderBar.value = Float(AudioManage.shared.currentItemProgression ?? 0)
        self.sliderBar.maximumValue = Float(AudioManage.shared.currentItemDuration ?? 0)
    }
    
    @objc func audioPlayerDidChangeState(_ notification: Notification) {
        if(AudioManage.shared.state == AudioPlayerState.paused) {
            self.btnPlay.setImage(UIImage(named: "ic_play"), for: .normal)
        } else if(AudioManage.shared.state == AudioPlayerState.stopped) {
            self.btnPlay.setImage(UIImage(named: "ic_play"), for: .normal)
        } else if(AudioManage.shared.state == AudioPlayerState.playing) {
            self.btnPlay.setImage(UIImage(named: "ic_pause"), for: .normal)
        }
    }

    @objc func onPlaybackProgression() {
        self.lbProgress.text = Constants.format(duration: AudioManage.shared.currentItemProgression!)
        self.lbDuration.text = Constants.format(duration: AudioManage.shared.currentItemDuration!)
        self.sliderBar.maximumValue = Float(AudioManage.shared.currentItemDuration!)
        if self.isSeeking == false {
            self.sliderBar.value = Float(AudioManage.shared.currentItemProgression ?? 0)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        if(AudioManage.shared.state == AudioPlayerState.paused) {
            AudioManage.shared.resume()
        } else if(AudioManage.shared.state == AudioPlayerState.stopped) {
            AudioManage.shared.seek(to: 0) { status in
                
            }
            AudioManage.shared.resume();
        } else if(AudioManage.shared.state == AudioPlayerState.playing || AudioManage.shared.state == AudioPlayerState.buffering) {
            AudioManage.shared.pause();
        }
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if(counter > 3) {
            counter = 0
            AudioManage.shared.next()
        }
    }
    @IBAction func actionPrevious(_ sender: Any) {
        if(counter > 3) {
            counter = 0
            AudioManage.shared.previous()
        }
    }
    
    @IBAction func actionAddWaterMark(_ sender: Any) {
        if(playableItem.duration > 40) {
            let vc = TrimVC()
            vc.playableItem = self.playableItem
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = WaterMarkVC()
            var listSongDownload = PlayableItem.readFromFileEditJson(fileName: NAME_FILE_SAVE)
            Constants.saveVideoAsMP4ToDocumentDirectory(inputVideoURL: playableItem.url) {videoUrl, devicePath in
                DispatchQueue.main.async {
                    let playableItemSave = PlayableItem()
                    let playableItem = PlayableItem()
                    let nameAudioConvert = "\(devicePath).mp4"
                    playableItem._id = devicePath
                    playableItem.url = videoUrl
                    playableItem.title = nameAudioConvert
                    playableItem.pathDownloadInDevice = nameAudioConvert
                    listSongDownload.append(playableItem)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            writeString(aString: jsonString, fileName: NAME_FILE_SAVE)
                        }
                        vc.playableItem = playableItem
                        self.navigationController?.pushViewController(vc, animated: true)
                    } catch {
                        print("\(error)")
                    }
                }
            }
        }
       
       
    }
    func getVideoInfo(from videoURL: URL) -> (thumbnail: UIImage?, duration: TimeInterval?, fileName: String) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var thumbnail: UIImage?
        var duration: TimeInterval?
        
        if let cgImage = try? imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil) {
            thumbnail = UIImage(cgImage: cgImage)
        }
        
        duration = CMTimeGetSeconds(asset.duration)
        
        let fileName = videoURL.lastPathComponent
        
        return (thumbnail, duration, fileName)
    }

}
