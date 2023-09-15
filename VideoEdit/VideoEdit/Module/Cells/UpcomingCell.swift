import UIKit

class UpcomingCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static let height: CGFloat = 240

    @IBOutlet weak var collectionview: UICollectionView!
    
    var seeAllBlock: ((_ source: [Movie]) -> Void)?
    var selectItemBlock: ((_ item: Movie) -> Void)?
    var seeAllTVBlock: ((_ source: [Television]) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    var source: [Movie] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
            }
        }
    }
    
    var sourceTV: [Television] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: ItemWithRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: ItemWithRateCell.cellId)
        collectionview.delegate = self
        collectionview.dataSource = self
    }
    @IBAction func seeAll(_ sender: Any) {
        if self.source.count > 0 {
            seeAllBlock?(source)
        } else if self.sourceTV.count > 0 {
            seeAllTVBlock?(sourceTV)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.source.count > 0 {
            return self.source.count
        } else if self.sourceTV.count > 0 {
            return self.sourceTV.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.source.count > 0 {
            selectItemBlock?(source[indexPath.row])
        } else if self.sourceTV.count > 0 {
            selectItemTVBlock?(sourceTV[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemWithRateCell.cellId, for: indexPath) as! ItemWithRateCell
        if self.source.count > 0 {
            cell.imageURL = source[indexPath.row].posterURL
            cell.vote = source[indexPath.row].voteAverageText
        } else if self.sourceTV.count > 0 {
            cell.imageURL = sourceTV[indexPath.row].posterURL
            cell.vote = sourceTV[indexPath.row].voteAverageText
        }
        
        return cell
    }

}

