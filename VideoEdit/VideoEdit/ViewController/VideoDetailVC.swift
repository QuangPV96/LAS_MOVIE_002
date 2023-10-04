import UIKit

class VideoDetailVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clvVideo: UICollectionView!
    var listVideo: [VideoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        clvVideo.delegate = self
        clvVideo.dataSource = self
        clvVideo.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent //.default for black style
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
        cell.itemSelectBlock = {videoSelect, indexRow in
            let vc = PlayVC()
            var listPlayableItem = [PlayableItem]()
            self.listVideo.forEach { video in
                let playableItem = PlayableItem.convertToPlayableItem(videoModel: video)
                listPlayableItem.append(playableItem)
            }
            vc.playableItem = listPlayableItem[indexRow]
            vc.playableList = listPlayableItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = clvVideo.bounds.width/2-13
        let height = width + 8 + 18
        return CGSize(width: width, height: height)
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
