import UIKit

class PagerHomeCell: UICollectionViewCell, FSPagerViewDataSource,FSPagerViewDelegate  {

    static let height: CGFloat = 520
    
    var source: [Movie] = [] {
        didSet {
            if (pagerMovie != nil) {
                pagerMovie.reloadData()
                if pagerMovie.currentIndex == 0 {
                    if source.count > 0 {
                        let movie = source[0]
                        titleLabel.text = movie.title
                        releaseLabel.text = movie.release_date
                        genresLabel.text = movie.genreText
                        lengthLabel.text = "\(movie.vote_count)"
                        rateLabel.text = movie.ratingText
                    }
                }
            }
        }
    }
    
    var sourceTV: [Television] = [] {
        didSet {
            if (pagerMovie != nil) {
                pagerMovie.reloadData()
                if pagerMovie.currentIndex == 0 {
                    if sourceTV.count > 0 {
                        let movie = sourceTV[0]
                        titleLabel.text = movie.name
                        releaseLabel.text = movie.firstYearText
                        genresLabel.text = movie.genreText
                        lengthLabel.text = "\(movie.vote_count)"
                        rateLabel.text = movie.ratingText
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var pagerMovie: FSPagerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLength: UILabel!
    
    var selectItemBlock: ((_ item: Movie) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pagerMovie.dataSource = self
        self.pagerMovie.delegate = self
        self.pagerMovie.automaticSlidingInterval = 2.0
        self.pagerMovie.itemSize = CGSize(width: 240, height: 360)
        self.pagerMovie.transformer = FSPagerViewTransformer(type: .overlap)
        self.pagerMovie.register(UINib(nibName: "ImageItemCell", bundle: nil), forCellWithReuseIdentifier: "ImageItemCell")
        self.pagerMovie.isInfinite = true
    }

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if self.source.count > 0 {
            return self.source.count
        } else if self.sourceTV.count > 0 {
            return self.sourceTV.count
        } else {
            return 0
        }
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ImageItemCell", at: index) as! ImageItemCell
        if self.source.count > 0 {
            cell.imageURL = source[index].posterURL
        } else if self.sourceTV.count > 0 {
            cell.imageURL = sourceTV[index].posterURL
        }
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        if self.source.count > 0 {
            selectItemBlock?(source[index])
        } else if self.sourceTV.count > 0 {
            selectItemTVBlock?(sourceTV[index])
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if self.source.count > 0 {
            let movie = source[pagerView.currentIndex]
            titleLabel.text = movie.title
            releaseLabel.text = movie.release_date
            genresLabel.text = movie.genreText
            lengthLabel.text = "\(movie.vote_count)"
            rateLabel.text = movie.ratingText
        } else if self.sourceTV.count > 0 {
            let movie = sourceTV[pagerView.currentIndex]
            titleLabel.text = movie.name
            releaseLabel.text = movie.firstYearText
            genresLabel.text = movie.genreText
            lengthLabel.text = "\(movie.vote_count)"
            rateLabel.text = movie.ratingText
        }
    }
}

