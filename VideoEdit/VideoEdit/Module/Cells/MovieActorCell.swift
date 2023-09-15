import UIKit
import SDWebImage

class MovieActorCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    //MARK: -properties
    static let heigt: CGFloat = 240

    
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    
    var seeAllActor: ((_ source: [People]) -> Void)?
    var onSelected: ((_ item: People) -> Void)?
    
    var source: [People] = [] {
        didSet {
            actorsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        actorsCollectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
    }
    
    
    @IBAction func seeAllHandle(_ sender: Any) {
        seeAllActor?(source)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
        cell.imageURL = source[indexPath.row].profileURL
        cell.title = source[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 117, height: 175)
    }
}
