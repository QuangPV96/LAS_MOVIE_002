import UIKit
import StoreKit

class HomeVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var listIDCell: [String] = [
        PagerHomeCell.cellId,
        AdmobNativeAdCell.cellId,
        AppLovinNativeAdCell.cellId,
        NewHomeCell.cellId,
        TopRateCell.cellId,
        MovieActorCell.cellId
    ]
    var genresVM: MovieGenreVM = MovieGenreVM()
    
    var nowPlayingVM: MovieNowPlayingVM = MovieNowPlayingVM()
    var popularVM: MoviePopularVM = MoviePopularVM()
    var topRatedVM: TelevisionTopRatedVM = TelevisionTopRatedVM()
    var popularPeopleVM: PeoplePopularVM = PeoplePopularVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: PagerHomeCell.cellId, bundle: nil), forCellWithReuseIdentifier: PagerHomeCell.cellId)
        collectionView.register(UINib(nibName: NewHomeCell.cellId, bundle: nil), forCellWithReuseIdentifier: NewHomeCell.cellId)
        collectionView.register(UINib(nibName: TopRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: TopRateCell.cellId)
        collectionView.register(UINib(nibName: MovieActorCell.cellId, bundle: nil), forCellWithReuseIdentifier: MovieActorCell.cellId)
        collectionView.registerItem(cell: AdmobNativeAdCell.self)
        collectionView.registerItem(cell: AppLovinNativeAdCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nowPlayingVM.bindViewModelToController = {
            self.collectionView.reloadData()
        }
        nowPlayingVM.loadData()
        
        popularVM.bindViewModelToController = {
            self.collectionView.reloadData()
        }
        popularVM.loadData()
        
        topRatedVM.bindViewModelToController = {
            self.collectionView.reloadData()
        }
        topRatedVM.loadData()
        
        genresVM.bindViewModelToController = {
            self.collectionView.reloadData()
        }
        genresVM.loadData()
        
        popularPeopleVM.bindViewModelToController = {
            self.collectionView.reloadData()
            self.moreAppOrRateApp()
        }
        popularPeopleVM.loadData()
    }
    
    private func moreAppOrRateApp(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .notDetermined {
                let moreApp: DDictionary? = DataCommonModel.shared.extraFind("more_app")
                if moreApp != nil {
                    let appid = moreApp!["appid"] as? String
                    let message = moreApp!["message"] as? String
                    if appid != nil && message != nil {
                        self.presentAlertInstall(appid: appid!, message: message!)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                            self?.presentRatePopup()
                        })
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                        self?.presentRatePopup()
                    })
                }
            } else {
                ApplicationHelper.shared.requestAuthorization { _ in
                    ApplicationHelper.shared.addScheduleEveryday(title: AppSetting.titleNoti, body: AppSetting.contentNoti, hour: 21, minute: 00)
                }
            }
        }
    }
    
    private func presentRatePopup() {
        if !DataCommonModel.shared.isRating {
            return
        }
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: windowScene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func presentAlertInstall(appid: String, message: String) {
        let alert = UIAlertController(title: "More App For You", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let url = URL(string: "https://itunes.apple.com/app/id\(appid)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listIDCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listIDCell[indexPath.row] {
        case PagerHomeCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagerHomeCell.cellId, for: indexPath) as! PagerHomeCell
            cell.source = nowPlayingVM.data.sorted(by: {$0.vote_average > $1.vote_average})
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            return cell
        case NewHomeCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewHomeCell.cellId, for: indexPath) as! NewHomeCell
            cell.source = popularVM.data.sorted(by: {$0.vote_average > $1.vote_average})
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllBlock = { items in
                self.openListMovieMore(type: ListType.moviePopular, data: items)
            }
            return cell
        case TopRateCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRateCell.cellId, for: indexPath) as! TopRateCell
            cell.sourceTV = topRatedVM.data.sorted(by: {$0.vote_average > $1.vote_average})
            cell.selectItemTVBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllTVBlock = { items in
                self.openListMovieMore(type: ListType.tvshowTopRated, data: items)
            }
            return cell
        case MovieActorCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieActorCell.cellId, for: indexPath) as! MovieActorCell
            cell.source = popularPeopleVM.data
            cell.onSelected = { item in
                self.openActorDetail(item.id)
            }
            
            cell.seeAllActor = { items in
                self.openListActor()
            }
            return cell
        case AppLovinNativeAdCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppLovinNativeAdCell.cellId, for: indexPath) as! AppLovinNativeAdCell
            cell.nativeAd = super.applovinAdView
            return cell
        case AdmobNativeAdCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdmobNativeAdCell.cellId, for: indexPath) as! AdmobNativeAdCell
            cell.nativeAd = super.admobAd
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var h: CGFloat = 0
        switch listIDCell[indexPath.row] {
        case PagerHomeCell.cellId:
            h = nowPlayingVM.getSizeData() == 0 ? 0 : PagerHomeCell.height
        case NewHomeCell.cellId:
            h = popularVM.getSizeData() == 0 ? 0 : NewHomeCell.height
        case TopRateCell.cellId:
            h = topRatedVM.getSizeData() == 0 ? 0 : TopRateCell.height
        case AdmobNativeAdCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.admobAd != nil {
                    h = AdmobNativeAdCell.height
                }
            }
        case AppLovinNativeAdCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.applovinAdView != nil {
                    h = AppLovinNativeAdCell.height
                }
            }
        case MovieActorCell.cellId:
            h = popularPeopleVM.getSizeData() == 0 ? 0 : MovieActorCell.heigt
        default:
            h = 0
        }
        return .init(width: UIScreen.main.bounds.size.width, height: h)
    }

}
