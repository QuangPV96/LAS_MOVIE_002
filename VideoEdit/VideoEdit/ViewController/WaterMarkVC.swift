//
//  WaterMarkVC.swift
//  VideoEdit
//
//  Created by apple on 10/08/2023.
//

import UIKit
import AVFoundation

class WaterMarkVC: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UITextFieldDelegate,FFmpegDelegate, PopupSaveDelegate{
    @IBOutlet weak var vCancel: UIView!
    
    @IBOutlet weak var vSave: PView!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var viewPlayer: PView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var tfWaterMark: UITextField!
    @IBOutlet weak var clvColor: UICollectionView!
    @IBOutlet weak var clvFont: UICollectionView!
    @IBOutlet weak var widthClvColor: NSLayoutConstraint!
    
    @IBOutlet weak var vShadow: UIView!
    @IBOutlet weak var vText: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var vAddText: UIView!
    @IBOutlet weak var constrantBottomFont: NSLayoutConstraint!
    private var indexRow = 2
    private var indexFont = 0
    private var fontName = "BabyBoo"
    private var colorSelect = 0xFFFFFF
    private var colors: [Int] = [0xFF6161, 0x4CDBF9,0xFFFFFF, 0x5441D1, 0xFFB629]
    var fonts: [String] = ["BabyBoo", "BebasNeue-Regular","Brice-Regular","Chillax-Medium"]
    var playableItem = PlayableItem()
    var isSeeking: Bool = false
    let customView = UIView()
    var newX = 0.0
    var newY = 0.0
    var playableList = [PlayableItem]()
    var popupView: PopupSaveView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllerToRemove = "TrimVC"
        // Tìm view controller trong mảng viewControllers
        if let indexToRemove = navigationController?.viewControllers.firstIndex(where: { $0.title == viewControllerToRemove }) {
            navigationController?.viewControllers.remove(at: indexToRemove)
        }
        playableList.append(playableItem)
        AudioManage.shared.play(items: playableList, startAtIndex: 0)

        if AudioManage.shared.currentItem!.artworkImage != nil {
            self.imgThumb.image = AudioManage.shared.currentItem!.artworkImage!
        }
        self.sliderBar.maximumValue = Float(AudioManage.shared.currentItemDuration ?? 0)
        self.sliderBar.value = Float(AudioManage.shared.currentItemProgression ?? 0)
        self.btnPlay.setImage(UIImage(named: "ic_pause"), for: .normal)
        self.sliderBar.addTarget(self, action: #selector(handleSliderChangeValue(sender:event:)), for: .allEvents)
        
        tfWaterMark.delegate = self
        clvColor.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        clvColor.delegate = self
        clvColor.dataSource = self
        clvFont.register(UINib(nibName: "FontCell", bundle: nil), forCellWithReuseIdentifier: "FontCell")
        clvFont.delegate = self
        clvFont.dataSource = self
        tfWaterMark.attributedPlaceholder = NSAttributedString(
            string: "Enter your watermark",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "FFFFFF", alpha: 0.25)]
        )
        widthClvColor.constant = CGFloat(colors.count*36 + (colors.count - 1)*8)
        // Đăng ký thông báo khi bàn phím sẽ hiển thị
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Đăng ký thông báo khi bàn phím sẽ ẩn
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Đăng ký sự kiện chạm vào giao diện để ẩn bàn phím
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        vText.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
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
    //    func getVideoFrameSize(from videoURL: URL) -> CGSize? {
    //        let asset = AVAsset(url: videoURL)
    //
    //        if let videoTrack = asset.tracks(withMediaType: .video).first {
    //            let naturalSize = videoTrack.naturalSize
    //            let transform = videoTrack.preferredTransform
    //
    //            // Chú ý: Nếu video có xoay ngang (landscape), bạn cần swap chiều rộng và chiều cao
    //            let videoSize = naturalSize.applying(transform)
    //            let frameSize = CGSize(width: abs(videoSize.width), height: abs(videoSize.height))
    //            vAddVideo.translatesAutoresizingMaskIntoConstraints = false // Tắt tự động tạo constraints từ frame
    //            NSLayoutConstraint.activate([
    //                vAddVideo.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor),
    //                vAddVideo.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor),
    //                vAddVideo.heightAnchor.constraint(equalToConstant: videoSize.height),
    //                vAddVideo.widthAnchor.constraint(equalToConstant: videoSize.width)
    //            ])
    //            return frameSize
    //        }
    //
    //        return nil
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    
        
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
        self.sliderBar.maximumValue = Float(AudioManage.shared.currentItemDuration!)
        if self.isSeeking == false {
            self.sliderBar.value = Float(AudioManage.shared.currentItemProgression ?? 0)
        }
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        if(AudioManage.shared.state == AudioPlayerState.paused) {
            AudioManage.shared.resume();
        } else if(AudioManage.shared.state == AudioPlayerState.stopped) {
            AudioManage.shared.seek(to: 0) { status in
                
            }
            AudioManage.shared.resume();
        } else if(AudioManage.shared.state == AudioPlayerState.playing || AudioManage.shared.state == AudioPlayerState.buffering) {
            AudioManage.shared.pause();
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let viewToMove = recognizer.view else { return }
        
        let translation = recognizer.translation(in: viewToMove.superview)
        
        newX = min(max(viewToMove.center.x + translation.x, viewToMove.bounds.width / 2), viewToMove.superview!.bounds.width - viewToMove.bounds.width / 2)
        newY = min(max(viewToMove.center.y + translation.y, viewToMove.bounds.height / 2), viewToMove.superview!.bounds.height - viewToMove.bounds.height / 2)
        viewToMove.center = CGPoint(x: newX, y: newY)
        recognizer.setTranslation(.zero, in: viewToMove.superview)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
    }
    // Hàm được gọi khi bàn phím sắp hiển thị
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height + 12
            constrantBottomFont.constant = keyboardHeight
            clvFont.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioManage.shared.stop()
        
    }
    
    // Hàm được gọi khi bàn phím sắp ẩn
    @objc func keyboardWillHide(notification: Notification) {
        clvFont.isHidden = true
    }
    @objc func handleTap() {
        // Ẩn bàn phím
        view.endEditing(true)
    }
    // Hàm từ UITextFieldDelegate, được gọi khi nhấn Return trên bàn phím
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ẩn bàn phím khi nhấn Return
        textField.resignFirstResponder()
        return true
    }
    func getKeyboardHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if let keyboardFrame = window?.safeAreaInsets.bottom {
            return keyboardFrame
        }
        return 160
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvFont) {
            return fonts.count
        }
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvFont) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontCell", for: indexPath) as! FontCell
            let row = indexPath.row
            cell.setData(item: fonts[row], row: row, itemSelect: indexFont)
            cell.selectItemBlock = { [self] itemSelect in
                indexFont = itemSelect
                fontName = fonts[itemSelect]
                clvFont.reloadData()
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        let row = indexPath.row
        cell.setData(color: colors[row], row: row, indexRow: indexRow)
        cell.itemSelectBlock = { [self] indexSelect in
            indexRow = indexSelect
            colorSelect = colors[indexSelect]
            clvColor.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(clvFont == collectionView) {
            return CGSize(width: 52, height: 36)
        }
        return CGSize(width: 36, height: 36)
    }
    func error() {
        DispatchQueue.main.async {
            self.hideLoading()
        }
    }
    func finish() {
        DispatchQueue.main.async {
            self.hideLoading()
        }
    }
    
    @IBAction func btnSaveAddText(_ sender: Any) {
        vAddText.isHidden = true
        vCancel.isHidden = false
        vSave.isHidden = false
        vText.isHidden = false
        lblText.text = tfWaterMark.text
        lblText.font = UIFont(name: fontName, size: 20)
        lblText.textColor = UIColor(hex: colorSelect)
    }
    @IBAction func btnCancelAddText(_ sender: Any) {
        vAddText.isHidden = true
        vCancel.isHidden = false
        vSave.isHidden = false
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        vShadow.isHidden = false
        let heightView = getKeyboardHeight()  + 24
        popupView = PopupSaveView(frame: CGRect(x: 16, y: heightView, width: ActivityEx.screenWidth()-32, height: 203))
        popupView.lblName1.text = playableItem.title
        popupView.delegate = self
        popupView.center = view.center
        popupView.alpha = 1
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            //use if you want to darken the background
            //self.viewDim.alpha = 0.8
            //go back to original form
            self.popupView.transform = .identity
            self.vShadow.isHidden = false
        })
    }
    func convertColorFormat(_ color: Int) -> String {
        // Xoá ký tự "0x" nếu có
        if(color == 0xFF6161){
            return "red"
        }else if(color == 0x4CDBF9){
            return "blue"
        }else if(color == 0xFFFFFF){
            return "white"
        }else if(color == 0x5441D1) {
            return "purple"
        }else {
            return "orange"
        }
    }
    func dissmiss() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
        }) { (success) in
            self.popupView.removeFromSuperview()
            self.vShadow.isHidden = true
        }
    }
    func cancel() {
        dissmiss()
    }
    func save(txt: String) {
        let nameTxt = txt.replacingOccurrences(of: " ", with: "")
        dissmiss()
        showLoading()
        let color = convertColorFormat(colorSelect)
        FFmpegManager.shared.addTextToVideoCmd(videoUrl: playableItem.url.path, fontName: fontName, text: lblText.text ?? "", name: nameTxt, x: "\(newX)", y: "\(newY)", fontColor: color)
        FFmpegManager.shared.delegate = self
    }
    
}

