import UIKit

class MovieDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var listIDMovieCell: [String] = [
        DetailInforCell.cellId,
        DetailIntroduceCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        DetailScenesCell.cellId,
        DetailTrailerCell.cellId,
        DetailMoreLikeCell.cellId
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var movieId: Int = 0
    var movieName: String = ""
    fileprivate var hashmap: [[String:String]] = []
    fileprivate var castSelected: Cast?
    fileprivate var collapsedOverview: Bool = true
    fileprivate var collapsedOverviewPeople: Bool = true
    fileprivate var collapsedOverviewActing: Bool = true
    
    fileprivate var movieDetailVM: MovieDetailVM?
    fileprivate var movieRecommendationVM: MovieRecommendationVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: DetailInforCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailInforCell.cellId)
        tableView.register(UINib(nibName: DetailIntroduceCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailIntroduceCell.cellId)
        tableView.register(UINib(nibName: DetailScenesCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailScenesCell.cellId)
        tableView.register(UINib(nibName: DetailTrailerCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailTrailerCell.cellId)
        tableView.register(UINib(nibName: DetailMoreLikeCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailMoreLikeCell.cellId)
        tableView.registerItem(cell: AdmobNativeAdTableCell.self)
        tableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        movieDetailVM = MovieDetailVM(id: movieId)
        movieDetailVM!.bindViewModelToController = {
            self.tableView.reloadData()
        }
        movieDetailVM!.loadData()
        
        movieRecommendationVM = MovieRecommendationVM(id: movieId)
        movieRecommendationVM?.bindViewModelToController = {
            self.tableView.reloadData()
        }
        movieRecommendationVM?.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func watchNowClick() {
        self.watchMo()
    }
    
    private func watchMo(){
        guard let detail = self.movieDetailVM?.data else { return }
        NetworkHelper.shared.loadM(detail.title, year: detail.yearInt, imdb: detail.imdb) { [weak self] data in
            if data.count == 0 {
                self?.alertNotLink {
                    NetworkHelper.shared.rport(name: detail.title,
                                               type: MediaType.movie.rawValue,
                                               year: detail.yearInt,
                                               imdb: detail.imdb,
                                               content: emptylink)
                }
                return
            }
            
            self?.loadView.show()
            AdsInterstitialHandle.shared.tryToPresent(loadView: self!.loadView) {
                let player = ZemPlayerController.makeController()
                player.type = .movie
                player.name = detail.title
                player.data = data
                player.imdbid = detail.imdb
                player.year = detail.yearInt
                self?.present(player, animated: true)
            }
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIDMovieCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (listIDMovieCell[indexPath.row]){
        case DetailInforCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInforCell.cellId) as! DetailInforCell
            cell.movie = movieDetailVM?.data
            return cell
        case DetailIntroduceCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailIntroduceCell.cellId) as! DetailIntroduceCell
            cell.isCollapsed = collapsedOverview
            cell.onChangedState = { collapsed in
                self.collapsedOverview = collapsed
                self.tableView.reloadData()
            }
            cell.watchNowBlock = watchNowClick
            cell.overview = movieDetailVM?.data == nil ? "" : movieDetailVM!.data?.overview
            return cell
        case DetailScenesCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailScenesCell.cellId) as! DetailScenesCell
            cell.source = movieDetailVM?.data?.images?.backdrops ?? []
            return cell
        case DetailTrailerCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTrailerCell.cellId) as! DetailTrailerCell
            cell.source = movieDetailVM?.data?.videos?.results ?? []
            cell.onPlay = { video in
                self.openTrailer(self.movieDetailVM!.data!, key: video.key)
            }
            return cell
        case DetailMoreLikeCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailMoreLikeCell.cellId) as! DetailMoreLikeCell
            cell.source = movieRecommendationVM?.data ?? []
            cell.selectItemBlock = { movie in
                self.openDetail(movie)
            }
            
            cell.selectItemTVBlock = { tv in
                self.openDetail(tv)
            }
            
            return cell
        case AppLovinNativeAdTableCell.cellId:
            let cell: AppLovinNativeAdTableCell = tableView.dequeueReusableCell()
            cell.nativeAd = super.applovinAdView
            return cell
        case AdmobNativeAdTableCell.cellId:
            let cell: AdmobNativeAdTableCell = tableView.dequeueReusableCell()
            cell.nativeAd = super.admobAd
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (listIDMovieCell[indexPath.row]){
        case DetailInforCell.cellId:
            return movieDetailVM?.data == nil ? 0 : DetailInforCell.height
        case DetailIntroduceCell.cellId:
            return movieDetailVM?.data == nil ? 0 : DetailIntroduceCell.height
        case DetailScenesCell.cellId:
            return (movieDetailVM?.data == nil || ((movieDetailVM?.data?.images?.backdrops ?? []).count == 0)) ? 0 : DetailScenesCell.height
        case DetailTrailerCell.cellId:
            return (movieDetailVM?.data == nil || ((movieDetailVM?.data?.videos!.results ?? []).count == 0)) ? 0 : DetailTrailerCell.height
        case DetailMoreLikeCell.cellId:
            return movieRecommendationVM?.data.count == 0 ? 0 : DetailMoreLikeCell.height
        case AdmobNativeAdTableCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.admobAd != nil {
                    return AdmobNativeAdTableCell.height
                } else {
                    return 0
                }
            } else {
                return 0
            }
        case AppLovinNativeAdTableCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.applovinAdView != nil {
                    return AppLovinNativeAdTableCell.height
                } else {
                    return 0
                }
            } else {
                return 0
            }
        default:
            return UITableView.automaticDimension
        }
    }
}
