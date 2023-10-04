import UIKit
import GoogleMobileAds
import AppLovinSDK
import AppTrackingTransparency

enum ListType: Int {
    case moviePopular = 0
    case tvshowTopRated
    case tvshowAirToday
}

enum GenreType {
    case movie
    case television
}

class BaseVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var nativeIndex: Int = 0
    var loadedNative: Bool = false
    
    fileprivate var admobNative: AdmobNative?
    fileprivate var applovinNative: ApplovinNative?
    
    var admobAd: GADNativeAd?
    var applovinAdView: MANativeAdView?
    
    let loadView = PALoadingView()
    
    // MARK: - life cycle viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadView.setMessage("Loading ads...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func hasRequestTrackingIDFA() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    func loadNativeAd(_ completion: @escaping () -> Void) {
        if hasRequestTrackingIDFA() == false {
            return
        }
        
        let nativesAvailable = DataCommonModel.shared.adsAvailableFor(.native)
        if nativeIndex >= nativesAvailable.count {
            return
        }
        
        let name = nativesAvailable[nativeIndex].name
        nativeIndex += 1
        
        switch name {
        case .admob:
            if admobNative != nil { return }
            
            admobNative = AdmobNative(numberOfAds: 1, nativeDidReceive: { [weak self] natives in
                if natives.first != nil {
                    self?.loadedNative = true
                    self?.admobAd = natives.first
                    completion()
                }
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            admobNative?.preloadAd(controller: self)
            
        case .applovin:
            if applovinNative != nil { return }
            
            applovinNative = ApplovinNative(nativeDidReceive: { [weak self] (nativeAdView, nativeAd) in
                self?.loadedNative = true
                self?.applovinAdView = nativeAdView
                completion()
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            applovinNative?.preloadAd(controller: self)
            
        }
    }
    
    func numberOfNatives() -> Int {
        return admobAd != nil || applovinAdView != nil ? 1 : 0
    }
}

// MARK: - public
extension BaseVC {
    func openDetail(_ movie: Movie) {
        self.loadView.show()
        AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }

            let movieDetail: MovieDetailVC = MovieDetailVC()
            movieDetail.movieId = movie.id
            movieDetail.movieName = movie.title
            navi.pushViewController(movieDetail, animated: true)
        }
    }

    func openDetail(_ tele: Television) {
        self.loadView.show()
        AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
            self.loadView.dismiss()
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let teleDetail: TVShowDetailVC = TVShowDetailVC()
            teleDetail.tvId = tele.id
            navi.pushViewController(teleDetail, animated: true)
        }
    }

    func openListActor() {
        self.loadView.show()
        AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
            self.loadView.dismiss()
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let actorDetail: ListActorVC = ListActorVC()
            navi.pushViewController(actorDetail, animated: true)
        }
    }

    func openActorDetail(_ personID: Int) {
        self.loadView.show()
        AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
            self.loadView.dismiss()
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let actorDetail: ActorDetailVC = ActorDetailVC()
            actorDetail.actorId = personID
            navi.pushViewController(actorDetail, animated: true)
        }
    }

    func openListMovieMore(type: ListType, data: [Any] ){
        self.loadView.show()
        AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
            self.loadView.dismiss()
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let moreListDetail: ListMediaVC = ListMediaVC()
            moreListDetail.typeSelected = type
            moreListDetail.listData = data
            navi.pushViewController(moreListDetail, animated: true)
        }
    }

    func openTrailer(_ movie: Movie, key: String) {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }

        let playYoutube: PlayTrailerVC = PlayTrailerVC()
        playYoutube.key = key
        playYoutube.movie = movie
        navi.pushViewController(playYoutube, animated: true)
    }

    func openTrailer(_ tele: Television, key: String) {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        let playYoutube: PlayTrailerVC = PlayTrailerVC()
        playYoutube.key = key
        playYoutube.tele = tele
        navi.pushViewController(playYoutube, animated: true)
    }
    func openSearch() {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }

        let searchvc: SearchVC = SearchVC()
        navi.pushViewController(searchvc, animated: true)
    }
    
}
