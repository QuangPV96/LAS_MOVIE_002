import UIKit

class NewHomeCell: UICollectionViewCell, FSPagerViewDataSource,FSPagerViewDelegate {

    static let height: CGFloat = 260
    
    @IBOutlet weak var pagerMovie: FSPagerView!
    @IBOutlet weak var pagerControl: FSPageControl!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAction: UILabel!
    @IBOutlet weak var lbVote: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    var seeAllBlock: ((_ source: [Movie]) -> Void)?
    var selectItemBlock: ((_ item: Movie) -> Void)?
    
    var seeAllTVBlock: ((_ source: [Television]) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    var source: [Movie] = [] {
        didSet {
            if (pagerMovie != nil) {
                lbTitle.text = "New Movies"
                pagerMovie.reloadData()
                pagerControl.numberOfPages = self.source.count > 5 ? 5 : self.source.count
                if pagerMovie.currentIndex == 0 {
                    if source.count > 0 {
                        let movie = source[0]
                        lbName.text = movie.title
                        lbAction.text = movie.genreText
                        lbVote.text = movie.ratingText
                    }
                }
            }
        }
    }
    
    var sourceTV: [Television] = [] {
        didSet {
            if (pagerMovie != nil) {
                lbTitle.text = "New TV Shows"
                pagerMovie.reloadData()
                pagerControl.numberOfPages = self.sourceTV.count > 5 ? 5 : self.sourceTV.count
                if pagerMovie.currentIndex == 0 {
                    if source.count > 0 {
                        let movie = sourceTV[0]
                        lbName.text = movie.name
                        lbAction.text = movie.genreText
                        lbVote.text = movie.ratingText
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pagerMovie.dataSource = self
        self.pagerMovie.delegate = self
        self.pagerMovie.automaticSlidingInterval = 2.0
        self.pagerMovie.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 32, height: 156)
        self.pagerMovie.transformer = FSPagerViewTransformer(type: .overlap)
        self.pagerMovie.register(UINib(nibName: "ImageItemCell", bundle: nil), forCellWithReuseIdentifier: "ImageItemCell")
        self.pagerMovie.isInfinite = true
        
        pagerControl.contentHorizontalAlignment = .center
        pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pagerControl.hidesForSinglePage = true
        pagerControl.setFillColor(UIColor(rgb: 0x233458), for: .selected)
        pagerControl.setFillColor(UIColor(rgb: 0x233458).withAlphaComponent(0.5), for: .normal)
        pagerControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }

    @IBAction func seeAll(_ sender: Any) {
        if self.source.count > 0 {
            seeAllBlock?(source)
        } else if self.sourceTV.count > 0 {
            seeAllTVBlock?(sourceTV)
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if self.source.count > 0 {
            return self.source.count > 5 ? 5 : self.source.count
        } else if self.sourceTV.count > 0 {
            return self.sourceTV.count > 5 ? 5 : self.sourceTV.count
        } else {
            return 0
        }
    }
    
    @IBAction func selectItem(_ sender: Any) {
        if self.source.count > 0 {
            selectItemBlock?(source[pagerMovie.currentIndex])
        } else if self.sourceTV.count > 0 {
            selectItemTVBlock?(sourceTV[pagerMovie.currentIndex])
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ImageItemCell", at: index) as! ImageItemCell
        if self.source.count > 0 {
            cell.imageURL = source[index].backdropURL
        } else if self.sourceTV.count > 0 {
            cell.imageURL = sourceTV[index].backdropURL
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
            lbName.text = movie.title
            lbAction.text = movie.genreText
            lbVote.text = movie.ratingText
        } else if self.sourceTV.count > 0 {
            let movie = sourceTV[pagerView.currentIndex]
            lbName.text = movie.name
            lbAction.text = movie.genreText
            lbVote.text = movie.ratingText
        }
        
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex
    }
}
