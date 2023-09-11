//
//  MergeVC.swift
//  VideoEdit
//
//  Created by apple on 08/08/2023.
//

import UIKit
import AVFoundation

class MergeVC: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , FFmpegDelegate{

    @IBOutlet weak var clvVideo: UICollectionView!
    var listVideo: [VideoModel] = FFmpegManager.shared.listAllVideo
    var listMerges: [VideoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let listSave = PlayableItem.readFromFileEditJson()
        listSave.forEach { playItem in
            let name = playItem.title
            var thumb = playItem.artworkImage
            let path = playItem.url
            if(thumb == nil) {
                thumb = UIImage(named: "ic_thumb_fake")
            }
            let videoModel = VideoModel(thumb!, videoSize: "", videoDuration: playItem.duration, videoName: name, videoPath: path!)
            listVideo.append(videoModel)
        }
        
        clvVideo.delegate = self
        clvVideo.dataSource = self
        clvVideo.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        
        // Do any additional setup after loading the view.
    }
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.isMerge  = true
        let videoModel = listVideo[indexPath.row]
        cell.setData(videoModel: videoModel, row: indexPath.row)
        cell.itemSelectBlock = { videoSelect, indexSelect in
            let model = self.listVideo[indexSelect]
            model.isNotSelect = !model.isNotSelect
            self.clvVideo.reloadItems(at: [IndexPath(row: indexSelect, section: 0)])
            self.listMerges = self.listVideo.filter({ model in
                return !model.isNotSelect
            })
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = clvVideo.bounds.width/3-13
        let height = width + 8 + 18
        return CGSize(width: width, height: height)
    }
    
    func error() {
        DispatchQueue.main.async {
            self.hideLoading()
        }
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
    }
    func finish() {
        DispatchQueue.main.async {
            self.hideLoading()
            let listSave = PlayableItem.readFromFileEditJson()
            let vc = PlayVC()
            vc.playableList = listSave
            vc.playableItem = listSave[listSave.count - 1]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
        }
        
    }
    @IBAction func actionMergeVideo(_ sender: Any) {
        let urls:[URL] = self.listMerges.map { video in
            return video.videoPath
        }
        showLoading()
        FFmpegManager.shared.mergeVideoCmd(videos: urls)
        FFmpegManager.shared.delegate = self
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
