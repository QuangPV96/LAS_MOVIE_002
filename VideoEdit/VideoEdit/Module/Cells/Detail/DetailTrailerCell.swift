import UIKit

class DetailTrailerCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let height: CGFloat = 143
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var source: [Video] = [] {
        didSet {
            if collectionview != nil {
                collectionview.reloadData()
                if source.count == 0 {
                    lbTitle.isHidden = true
                    collectionview.isHidden = true
                } else {
                    lbTitle.isHidden = false
                    collectionview.isHidden = false
                }
            }
        }
    }
    
    var onPlay: ((_ data: Video) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: DetailTrailerItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: DetailTrailerItemCell.cellId)
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
        onPlay?(source[indexPath.row])
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
        return CGSize(width: 163, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailTrailerItemCell.cellId, for: indexPath) as! DetailTrailerItemCell
        cell.video = source[indexPath.row]
        return cell
    }
    
}
