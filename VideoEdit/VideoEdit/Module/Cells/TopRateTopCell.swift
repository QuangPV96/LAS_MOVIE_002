import UIKit

class TopRateTopCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionview: UICollectionView!
    
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
    
    var selectItemBlock: ((_ item: Movie) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: TopRateTopItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: TopRateTopItemCell.cellId)
        collectionview.delegate = self
        collectionview.dataSource = self
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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.size.width - 32, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRateTopItemCell.cellId, for: indexPath) as! TopRateTopItemCell
        if self.source.count > 0 {
            cell.movie = source[indexPath.row]
        } else if self.sourceTV.count > 0 {
            cell.television = sourceTV[indexPath.row]
        }
        cell.index = indexPath.row
        return cell
    }


}
