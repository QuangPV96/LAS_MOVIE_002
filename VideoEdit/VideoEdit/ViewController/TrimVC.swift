import UIKit
import MediaPlayer
import AVKit

class TrimVC: BaseViewController{

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var viewPlayer: PView!
    @IBOutlet weak var cropVideoImageFrame: UIView!
    @IBOutlet weak var lbEndTime: UILabel!
    @IBOutlet weak var lbStartTime: UILabel!
    var cropsliderminimumValue : Double = 0.0
    var cropslidermaximumValue : Double = 0.0
    var playableItem = PlayableItem()
    
    let playerController = AVPlayerViewController()
    private var player: AVPlayer! {playerController.player}
    private var asset: AVAsset!
    
    var videoTotalsec: Int = 0
    var trimmer: VideoTrimmer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TrimVC"
        asset = AVURLAsset(url: playableItem.url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        playerController.player = AVPlayer()
        addChild(playerController)
        viewPlayer.addSubview(playerController.view)
        playerController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 720 / 1280)
        ])
        
        if playableItem.artworkImage != nil {
            self.imgThumb.image = playableItem.artworkImage!
        } else {
            self.imgThumb.image = UIImage(named: "ic_temp_home")
        }
        
        trimmer = VideoTrimmer()
        trimmer.minimumDuration = CMTime(seconds: 1, preferredTimescale: 600)
        trimmer.addTarget(self, action: #selector(didBeginTrimming(_:)), for: VideoTrimmer.didBeginTrimming)
        trimmer.addTarget(self, action: #selector(didEndTrimming(_:)), for: VideoTrimmer.didEndTrimming)
        trimmer.addTarget(self, action: #selector(selectedRangeDidChanged(_:)), for: VideoTrimmer.selectedRangeChanged)
        trimmer.addTarget(self, action: #selector(didBeginScrubbing(_:)), for: VideoTrimmer.didBeginScrubbing)
        trimmer.addTarget(self, action: #selector(didEndScrubbing(_:)), for: VideoTrimmer.didEndScrubbing)
        trimmer.addTarget(self, action: #selector(progressDidChanged(_:)), for: VideoTrimmer.progressChanged)
        cropVideoImageFrame.addSubview(trimmer)
        trimmer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trimmer.leadingAnchor.constraint(equalTo: cropVideoImageFrame.safeAreaLayoutGuide.leadingAnchor),
            trimmer.trailingAnchor.constraint(equalTo: cropVideoImageFrame.safeAreaLayoutGuide.trailingAnchor),
            trimmer.topAnchor.constraint(equalTo: cropVideoImageFrame.safeAreaLayoutGuide.topAnchor),
            trimmer.bottomAnchor.constraint(equalTo: cropVideoImageFrame.safeAreaLayoutGuide.bottomAnchor),
        ])
        trimmer.asset = asset
        updatePlayerAsset()

        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 30), queue: .main) { [weak self] time in
            guard let self = self else {return}
            let finalTime = self.trimmer.trimmingState == .none ? CMTimeAdd(time, self.trimmer.selectedRange.start) : time
            self.trimmer.progress = finalTime
        }
        updateLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(player != nil) {
            player.pause()
        }
    }
    
    private func saveTrimVideo(){
        let outputRange = trimmer.trimmingState == .none ? trimmer.selectedRange : asset.fullRange
        cropsliderminimumValue = Double(outputRange.start.value)/1000
        cropslidermaximumValue = Double(outputRange.start.value + outputRange.duration.value)/1000
        showLoading()
        player.pause()
        let  progressTime = trimmer.selectedRange.duration.displayInt
        if(progressTime > 40) {
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "The cut video is 40 seconds long")
            }
            return
        }
        OptiVideoEditor().trimVideo(sourceURL: playableItem.url, startTime:cropsliderminimumValue, endTime:cropslidermaximumValue, success: { (playableItem) in
            DispatchQueue.main.async {
                self.hideLoading()
                let vc = WaterMarkVC()
                vc.playableItem = playableItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }){ (error) in
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "Trim error. Try again later!")
            }
        }
    }

    @IBAction func actionSaveVideoTrim(_ sender: Any) {
        saveTrimVideo()
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didBeginTrimming(_ sender: VideoTrimmer) {
        updateLabels()
        player.pause()
        updatePlayerAsset()
    }

    @objc private func didEndTrimming(_ sender: VideoTrimmer) {
        updateLabels()
        player.play()
        updatePlayerAsset()
    }

    @objc private func selectedRangeDidChanged(_ sender: VideoTrimmer) {
        updateLabels()
    }

    @objc private func didBeginScrubbing(_ sender: VideoTrimmer) {
        updateLabels()
        player.pause()
    }

    @objc private func didEndScrubbing(_ sender: VideoTrimmer) {
        updateLabels()
        player.play()
    }

    @objc private func progressDidChanged(_ sender: VideoTrimmer) {
        updateLabels()
        let time = CMTimeSubtract(trimmer.progress, trimmer.selectedRange.start)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private func updateLabels() {
        lbStartTime.text = trimmer.selectedRange.start.displayString
        lbEndTime.text = trimmer.selectedRange.end.displayString
    }
    
    private func updatePlayerAsset() {
        let outputRange = trimmer.trimmingState == .none ? trimmer.selectedRange : asset.fullRange
        let trimmedAsset = asset.trimmedComposition(outputRange)
        if trimmedAsset != player.currentItem?.asset {
            player.replaceCurrentItem(with: AVPlayerItem(asset: trimmedAsset))
        }
    }
}
