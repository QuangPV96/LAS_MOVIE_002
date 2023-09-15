import UIKit

class SearchActorCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let height: CGFloat = 240
    
    var selectItemBlock: ((_ item: People) -> Void)?
    
    var source: [People] = [] {
        didSet {
            if actorCollectionView != nil {
                actorCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var actorCollectionView: UICollectionView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        actorCollectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        actorCollectionView.delegate = self
        actorCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if source.count > 0 {
            return source.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
        if self.source.count > 0 {
            cell.imageURL = source[indexPath.row].profileURL
            cell.title = source[indexPath.row].name
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.source.count > 0 {
            selectItemBlock?(source[indexPath.row])
        }
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
