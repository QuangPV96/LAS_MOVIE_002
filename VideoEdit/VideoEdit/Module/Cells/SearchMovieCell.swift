import UIKit

class SearchMovieCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    static let height: CGFloat = 240
    
    var selectItemBlock: ((_ item: Movie) -> Void)?
    
    var source: [Movie] = [] {
        didSet {
            if movieCollectionView != nil {
                movieCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieCollectionView.register(UINib(nibName: ItemWithRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: ItemWithRateCell.cellId)
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.source.count > 0 {
            return source.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemWithRateCell.cellId, for: indexPath) as! ItemWithRateCell
        if self.source.count > 0 {
            cell.imageURL = source[indexPath.row].posterURL
            cell.vote = source[indexPath.row].voteAverageText
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
