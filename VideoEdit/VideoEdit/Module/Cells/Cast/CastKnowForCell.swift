import UIKit

class CastKnowForCell: UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let height: CGFloat = 223
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var source: [Any] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
            }
        }
    }
    
    var selectItemBlock: ((_ data: Any) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: ItemWithRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: ItemWithRateCell.cellId)
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectItemBlock?(source[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemWithRateCell.cellId, for: indexPath) as! ItemWithRateCell
        let data = source[indexPath.row]
        if let movie = data as? Movie {
            cell.imageURL = movie.posterURL
            cell.vote = movie.voteAverageText
        }
        else if let tele = data as? Television {
            cell.imageURL = tele.posterURL
            cell.vote = tele.voteAverageText
        }
        return cell
    }
}
