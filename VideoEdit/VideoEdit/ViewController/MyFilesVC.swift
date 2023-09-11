//
//  MyFilesVC.swift
//  VideoEdit
//
//  Created by Trung Nguyễn on 07/08/2023.
//

import UIKit
import Photos

class MyFilesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var tbVideo: UITableView!
   private var listVideo: [VideoModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbVideo.register(UINib(nibName: "MyFileCell", bundle: nil), forCellReuseIdentifier: "MyFileCell")
        tbVideo.delegate = self
        tbVideo.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
    }
    func reloadData() {
        listVideo.removeAll()
        let listSave = PlayableItem.readFromFileEditJson()
        if(listSave.count == 0) {
            vEmpty.isHidden = false
        }
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
        if(listVideo.count > 0) {
            vEmpty.isHidden = true
        }
        tbVideo.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFileCell = tableView.dequeueReusableCell(withIdentifier: "MyFileCell", for: indexPath)
        as! MyFileCell
        let isHideLine = indexPath.row == listVideo.count-1
        cell.setData(videoModel: listVideo[indexPath.row], isHideLine: isHideLine, row: indexPath.row)
        cell.itemSelectBlock = {videoSelect, indexRow in
            let vc = PlayVC()
            var listPlayableItem = [PlayableItem]()
            self.listVideo.forEach { video in
                let playableItem = PlayableItem.convertToPlayableItem(videoModel: video)
                listPlayableItem.append(playableItem)
            }
            vc.playableItem = listPlayableItem[indexRow]
            vc.playableList = listPlayableItem
            vc.startAtIndex = indexRow
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(isPad()) {
            return 228
        }
        return 106
    }


    @IBAction func actionMergeVideo(_ sender: Any) {
        let vc = MergeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 

}
