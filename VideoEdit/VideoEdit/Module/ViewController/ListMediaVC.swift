import UIKit

class ListMediaVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var typeSelected: ListType = .moviePopular
    var listData: [Any]?
    var topRatedVM: TelevisionTopRatedVM = TelevisionTopRatedVM()
    
    var popularVM: MoviePopularVM = MoviePopularVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: ItemWithRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: ItemWithRateCell.cellId)
        collectionView.registerItem(cell: AdmobNativeAdCell.self)
        collectionView.registerItem(cell: AppLovinNativeAdCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.cr.addFootRefresh {
            // load more
            self.loadingIfNeed()
        }
        if typeSelected == .moviePopular {
            self.lbTitle.text = "New Movies"
            popularVM.bindViewModelToController = {
                self.collectionView.reloadData()
                self.collectionView.cr.endLoadingMore()
            }
            popularVM.loadData()
        } else if typeSelected == .tvshowTopRated {
            self.lbTitle.text = "TV Shows Top Rated"
            topRatedVM.bindViewModelToController = {
                self.collectionView.reloadData()
                self.collectionView.cr.endLoadingMore()
            }
            topRatedVM.loadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func loadingIfNeed() {
        if typeSelected == .moviePopular {
            if popularVM.isLoading { return }
            popularVM.loadData()
        } else if typeSelected == .tvshowTopRated {
            if topRatedVM.isLoading { return }
            topRatedVM.loadData()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeSelected == .moviePopular {
            return popularVM.getSizeData() + 2
        } else if typeSelected == .tvshowTopRated {
            return topRatedVM.getSizeData() + 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppLovinNativeAdCell.cellId, for: indexPath) as! AppLovinNativeAdCell
            cell.nativeAd = super.applovinAdView
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdmobNativeAdCell.cellId, for: indexPath) as! AdmobNativeAdCell
            cell.nativeAd = super.admobAd
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemWithRateCell.cellId, for: indexPath) as! ItemWithRateCell
            if typeSelected == .moviePopular {
                cell.imageURL = popularVM.data[indexPath.row - 2].posterURL
                cell.vote = popularVM.data[indexPath.row - 2].voteAverageText
            }else if typeSelected == .tvshowTopRated {
                cell.imageURL = topRatedVM.data[indexPath.row - 2].posterURL
                cell.vote = topRatedVM.data[indexPath.row - 2].voteAverageText
            }
            cell.cornerImage = 6
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            var h: CGFloat = 0
            if super.numberOfNatives() > 0 {
                if super.applovinAdView != nil {
                    h = AppLovinNativeAdCell.height
                }
            }
            return .init(width: collectionView.frame.size.width, height: h)
        } else if indexPath.row == 1 {
            var h: CGFloat = 0
            if super.numberOfNatives() > 0 {
                if super.admobAd != nil {
                    h = AdmobNativeAdCell.height
                }
            }
            return .init(width: collectionView.frame.size.width, height: h)
        } else {
            return .init(width: UIScreen.main.bounds.size.width/3 - 19, height: (UIScreen.main.bounds.size.width/3 - 19)*16/11)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row == 0 {

        } else if indexPath.row == 1 {

        } else {
            if typeSelected == .moviePopular {
                self.openDetail(popularVM.data[indexPath.row - 2])
            } else if typeSelected == .tvshowTopRated {
                self.openDetail(topRatedVM.data[indexPath.row - 2])
            }
        }
    }
}
