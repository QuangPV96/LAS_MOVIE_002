//
//  BoxVC.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 20/04/2023.
//

import UIKit
import BoxSDK
import AuthenticationServices

class BoxVC: UIViewController, SelectCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewDownload: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var files: [File] = [File]()
    var boxService = BoxService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FileCell", bundle: .main), forCellWithReuseIdentifier: "FileCell")
        
        boxService.awake()
        boxService.signIn { isSuccess in
            if isSuccess == true {
                self.btnLogin.setTitle("Logout", for: .normal)
                self.boxService.requestCurrentAccount { user in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()

                    }
                    self.lbTitle.text = user?.name
                }
                self.boxService.search(MediaEnum.video) { listFile, error in
                    self.files = listFile
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()

                    }
                }
            }
        }
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        if (btnLogin.title(for: .normal) == "Logout") {
            boxService.signOut()
            files = [File]()
            collectionView.reloadData()
            btnLogin.setTitle("Login", for: .normal)
        } else {
            boxService.signIn { isSuccess in
                self.btnLogin.setTitle("Logout", for: .normal)
                self.boxService.requestCurrentAccount { user in
                    self.lbTitle.text = user?.name
                }
                self.boxService.search(MediaEnum.video) { listFile, error in
                    self.files = listFile
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()

                    }
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! FileCell
        cell.setData(file: files[indexPath.row], selectCell: self, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func selectCell(index: Int) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(files[index].name!)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            DAppMessagesManage.shared.showMessage(messageType: .success, message: "This file has been downloaded !")
        } else {
            viewDownload.isHidden = false
            boxService.download(files[index]) { progress in
                DispatchQueue.main.async {
                    self.progressBar.progress = Float(progress.completedUnitCount*100/progress.totalUnitCount)
                }
                
            } completion: { status, urlString in
                if status == true {
                    self.viewDownload.isHidden = true
                    DAppMessagesManage.shared.showMessage(messageType: .success, message: "Download success!")
                    do {
                        let pathDownloadInDevice = self.files[index].name!
                        var listSongDownload = PlayableItem.readFromFileJson()
                        
                        let playableItem = PlayableItem()
                        playableItem._id = "\(Date().timeIntervalSince1970)"
                        playableItem.title = self.files[index].name!
                        playableItem.pathDownloadInDevice = pathDownloadInDevice
                        
                        listSongDownload.append(playableItem)
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            writeString(aString: jsonString, fileName: NAME_FILE_SAVE)
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print("\(error)")
                    }
                } else {
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                    } catch {
                        print("\(error)")
                    }
                    
                    self.viewDownload.isHidden = true
                    DAppMessagesManage.shared.showMessage(messageType: .error, message: "Download Failed!")
                }
            }
        }
    }
    
    func selectMoreCell(index: Int) {
        
    }
    
}
