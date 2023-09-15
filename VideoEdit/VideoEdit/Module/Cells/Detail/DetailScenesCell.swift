import UIKit

class DetailScenesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    static let height: CGFloat = 143
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var source: [MovieImageItem] = [] {
        didSet {
            if collectionview != nil {
                collectionview.reloadData()
                if source.count == 0 {
                    lbTitle.isHidden = true
                } else {
                    lbTitle.isHidden = false
                }
            }
        }
    }
    
    var sourceTV: [TelevisionImageItem] = [] {
        didSet {
            if collectionview != nil {
                collectionview.reloadData()
                if source.count == 0 {
                    lbTitle.isHidden = true
                } else {
                    lbTitle.isHidden = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: ImageItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ImageItemCell.cellId)
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if source.count > 0 {
            return self.source.count
        } else if sourceTV.count > 0 {
            return self.sourceTV.count
        } else {
            return 0
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageItemCell.cellId, for: indexPath) as! ImageItemCell
        if source.count > 0 {
            cell.imageURL = source[indexPath.row].filePathURL
        } else if sourceTV.count > 0 {
            cell.imageURL = sourceTV[indexPath.row].filePathURL
        }
        return cell
    }
}
