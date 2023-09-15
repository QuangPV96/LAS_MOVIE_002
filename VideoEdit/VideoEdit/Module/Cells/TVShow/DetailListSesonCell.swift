import UIKit

class DetailListSesonCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    static let height: CGFloat = 52
    
    var source: [TelevisionSeason] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var selectSeason: ((_ season: TelevisionSeason) -> Void)?
    
    var sesonSelect: TelevisionSeason? {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: DetailListSesonItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: DetailListSesonItemCell.cellId)
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
        selectSeason?(source[indexPath.row])
        sesonSelect = source[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = widthForLabel(text: source[indexPath.row].name ?? "", font: UIFont.systemFont(ofSize: 14), height: 36)
        return CGSize(width: width + 32, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailListSesonItemCell.cellId, for: indexPath) as! DetailListSesonItemCell
        cell.season = source[indexPath.row]
        if sesonSelect?.id == source[indexPath.row].id {
            cell.isCurrent = true
        } else {
            cell.isCurrent = false
        }
        return cell
    }
    
}
