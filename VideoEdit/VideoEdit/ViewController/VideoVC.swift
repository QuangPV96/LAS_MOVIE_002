import UIKit
import BetterSegmentedControl
import Photos
import MediaPlayer
import GoogleMobileAds

class VideoVC: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet weak var vPermission: PView!
    @IBOutlet weak var clvVideo: UICollectionView!
    @IBOutlet weak var vFolder: UIView!
    @IBOutlet weak var vVideo: UIView!
    @IBOutlet weak var vControl: BetterSegmentedControl!
    @IBOutlet weak var vParent: UIView!
    @IBOutlet weak var tbvFolder: UITableView!
    @IBOutlet weak var viewNativeAds: UIView!
    
    var listPlayableItem = [PlayableItem]()
    var listVideo: [VideoModel] = []
    var folders: [Folder] = []
    
    var adLoader: GADAdLoader!
    var nativeAdView: NativeSmallAdView!
    var nativeAd: GADNativeAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Control 6: Apple style
        // Control 1: Created and designed in IB
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidChangeState), name: Notification.Name(rawValue: "reloadData"), object: nil);
        clvVideo.delegate = self
        clvVideo.dataSource = self
        clvVideo.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        
        tbvFolder.delegate = self
        tbvFolder.dataSource = self
        tbvFolder.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "FolderCell")
        controlTab()
        permissonCheck()
        
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                               adTypes: [ .native ], options: nil)
        adLoader!.delegate = self
        adLoader!.load(GADRequest())
        
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
    }
    
    func setAdView(_ view: NativeSmallAdView) {
        nativeAdView = view
        self.viewNativeAds.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    }
    
    func permissonCheck() {
        PHPhotoLibrary.requestAuthorization { (status) in
                 switch status {
                 case .authorized:
                     DispatchQueue.main.async {
                         self.accessGranted() // Gọi hàm xử lý sau khi cấp quyền
                     }
                 case .denied, .restricted, .notDetermined:
                     DispatchQueue.main.async {
                         self.vPermission.isHidden = false
                     }
                     // Xử lý khi quyền bị từ chối, bị hạn chế, hoặc chưa xác định
                     break
                 @unknown default:
                     DispatchQueue.main.async {
                         self.vPermission.isHidden = false
                     }
                     break
                 }
             }
    }
    func accessGranted() {
        fetchVideosFromGallery()
        }
    @objc func audioPlayerDidChangeState(_ notification: Notification) {
        listVideo.removeAll()
        let listSave = PlayableItem.readFromFileEditJson()
        listSave.forEach { playItem in
            let name = playItem.title
            let thumb = playItem.artworkImage
            let path = playItem.url
            let videoModel = VideoModel(thumb!, videoSize: "", videoDuration: playItem.duration, videoName: name, videoPath: path!)
            listVideo.append(videoModel)
        }
        
        let listGallery = PlayableItem.readFromFileEditJson(fileName: NAME_FILE_SAVE)
        listSave.forEach { playItem in
            let name = playItem.title
            let thumb = playItem.artworkImage
            let path = playItem.url
            let videoModel = VideoModel(thumb!, videoSize: "", videoDuration: playItem.duration, videoName: name, videoPath: path!)
            listVideo.append(videoModel)
        }
        self.clvVideo.reloadData()
    }
    
    func getListVideoInFolder() {
        let listSave = PlayableItem.readFromFileEditJson()
        listSave.forEach { playItem in
            let name = playItem.title
            let thumb = playItem.artworkImage
            let path = playItem.url
            let videoModel = VideoModel(thumb!, videoSize: "", videoDuration: playItem.duration, videoName: name, videoPath: path!)
            listVideo.append(videoModel)
        }
    }
    func controlTab() {
        vControl.segments = LabelSegment.segments(withTitles: ["Videos", "Folders"],
                                                  normalFont: UIFont(name: "Poppins-SemiBold.ttf", size: 16),
                                                  normalTextColor: UIColor(hex: 0x999BB0), selectedFont: UIFont(name: "Poppins-SemiBold.ttf", size: 16),
                                                  selectedTextColor: UIColor(hex: 0x4E59FF))
        vControl.setOptions([.cornerRadius(10.0),
                             .backgroundColor(.clear),
                             .indicatorViewBackgroundColor(.white)
                            ])
        vControl.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
    }
    func fetchVideosFromGallery() {
        showLoading()
        listPlayableItem.removeAll()
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
            var videoGallery = [VideoModel]()
        let dispatchGroup = DispatchGroup()

            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    let asset = fetchResult.object(at: i)
                    let options = PHVideoRequestOptions()
                    options.isNetworkAccessAllowed = true
                    dispatchGroup.enter() // Notify the group that a task has started

                    PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
                        if let avAsset = avAsset as? AVURLAsset {
                            let videoURL = avAsset.url
                            Constants.getVideoInfo(from: asset, avAsset: avAsset, videoURL: videoURL) { listVideo in
                                DispatchQueue.main.async {
                                    listVideo.forEach { video in
                                        self.listVideo.append(video)
                                        videoGallery.append(video)
                                        let playableItem = PlayableItem.convertToPlayableItem(videoModel: video)
                                        self.listPlayableItem.append(playableItem)
                                    }
                                    dispatchGroup.leave()
                                }
                            }
                        } else {
                            dispatchGroup.leave()
                        }
                        
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main) { [self] in
                    let folder = Folder(name: "All Video", count: "\(self.listVideo.count)", list: self.listVideo)
                    self.folders.append(folder)
                    let folderGallery = Folder(name: "Gallery", count: "\(videoGallery.count)", list: listVideo)
                    self.folders.append(folderGallery)
                    let boxDriver = Folder(name: "Box Driver", count: "", list: [VideoModel]())
                    self.folders.append(boxDriver)
                    self.tbvFolder.reloadData()
                    self.clvVideo.reloadData()
                    FFmpegManager.shared.listAllVideo = videoGallery
                    self.hideLoading()
                }
                
            }else {
                self.hideLoading()
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "You don't have video to use this feature")
            }
        }
    func saveVideoToDocumentDirectory(videoURL: URL)-> URL {
        let fileManager = FileManager.default
        
        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationURL = documentsURL.appendingPathComponent(videoURL.lastPathComponent)
            
            try fileManager.copyItem(at: videoURL, to: destinationURL)
            return documentsURL
        } catch {
        }
        return videoURL
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FolderCell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        as! FolderCell
        cell.setData(folder: folders[indexPath.row])
        cell.itemSelectBlock = { folder in
            if(folder.name == "Box Driver") {
                let vc = BoxVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = VideoDetailVC()
                vc.listVideo = self.listVideo
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.isMerge = false
        let videoModel = listVideo[indexPath.row]
        cell.setData(videoModel: videoModel, row: indexPath.row)
        cell.itemSelectBlock = { [self]videoSelect, indexRow in
            let vc = PlayVC()
            vc.playableItem = listPlayableItem[indexRow]
            vc.playableList = listPlayableItem
            vc.startAtIndex = indexRow
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = clvVideo.bounds.width/2-13
        let height = width + 8 + 18
        return CGSize(width: width, height: height)
    }
    // MARK: - Action handlers
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            vVideo.isHidden = false
            vFolder.isHidden = true
           
        } else {
            vVideo.isHidden = true
            vFolder.isHidden = false
        }
    }

    @IBAction func actionDownload(_ sender: Any) {
        let vc = MergeVC()
        vc.listVideo = listVideo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openSetting(_ sender: Any) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

extension VideoVC : GADNativeAdLoaderDelegate, GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        if listVideo.count > 0 {
            guard let nibObjects = Bundle.main.loadNibNamed("NativeSmallAdView", owner: nil, options: nil),
                let adView = nibObjects.first as? NativeSmallAdView else {
                    assert(false, "Could not load nib file for adView")
                    return
            }
            
            setAdView(adView)
            
            self.nativeAd = nativeAd
            nativeAdView.setViewForAds(nativeAd: self.nativeAd!)
        }
    }
}
