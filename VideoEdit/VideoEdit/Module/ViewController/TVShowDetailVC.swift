import UIKit

class TVShowDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var listIDTelevisionCell: [String] = [
        DetailInforCell.cellId,
        DetailIntroduceCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        DetailScenesCell.cellId,
        DetailTrailerCell.cellId,
        DetailMoreLikeCell.cellId
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var tvId: Int = 0
    var indexTab: Int = 0
    fileprivate var castSelected: Cast?
    fileprivate var collapsedOverview: Bool = true
    fileprivate var collapsedOverviewPeople: Bool = true
    fileprivate var collapsedOverviewActing: Bool = true
    
    fileprivate var televisionDetailVM: TelevisionDetailVM?
    fileprivate var televisionRecommendationVM: TelevisionRecommendationVM?
    fileprivate var peopleDetailVM: PeopleDetailVM?
    fileprivate var peopleCreditVM: PeopleCreditVM!
    fileprivate var seasonDetailVM: TelevisionSeasonDetailVM!
    
    fileprivate var sesonSelect: TelevisionSeason?
    
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
        
        televisionDetailVM = TelevisionDetailVM(id: tvId)
        televisionDetailVM!.bindViewModelToController = { [self] in
            if (self.televisionDetailVM!.data?.seasons!.count)! > 0 {
                self.sesonSelect = self.televisionDetailVM!.data?.seasons?[0]
                
                self.seasonDetailVM = TelevisionSeasonDetailVM(tvId: tvId, seasonNumber: (self.sesonSelect?.season_number)!)
                self.seasonDetailVM?.bindViewModelToController = {
                    self.tableView.reloadData()
                }
                seasonDetailVM?.loadData()
                
            }
            self.tableView.reloadData()
        }
        televisionDetailVM!.loadData()
        
        televisionRecommendationVM = TelevisionRecommendationVM(id: tvId)
        televisionRecommendationVM?.bindViewModelToController = {
            self.tableView.reloadData()
        }
        televisionRecommendationVM?.loadData()
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
        if let television = self.televisionDetailVM?.data {
            let seasonController: TVShowSeasonVC = TVShowSeasonVC()
            seasonController.tvId = television.id
            seasonController.name = television.name
            seasonController.seasons = television.seasons ?? []
            seasonController.television = television
            navigationController?.pushViewController(seasonController, animated: true)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIDTelevisionCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch listIDTelevisionCell[indexPath.row] {
        case DetailInforCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInforCell.cellId) as! DetailInforCell
            cell.television = televisionDetailVM?.data
            return cell
        case DetailIntroduceCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailIntroduceCell.cellId) as! DetailIntroduceCell
            cell.isCollapsed = collapsedOverview
            cell.onChangedState = { collapsed in
                self.collapsedOverview = collapsed
                self.tableView.reloadData()
            }
            cell.watchNowBlock = watchNowClick
            cell.overview = televisionDetailVM?.data == nil ? "" : televisionDetailVM!.data?.overview
            return cell
        case DetailScenesCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailScenesCell.cellId) as! DetailScenesCell
            cell.sourceTV = televisionDetailVM?.data?.images?.backdrops ?? []
            return cell
        case DetailTrailerCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTrailerCell.cellId) as! DetailTrailerCell
            cell.source = televisionDetailVM?.data?.videos?.results ?? []
            cell.onPlay = { video in
                self.openTrailer(self.televisionDetailVM!.data!, key: video.key)
            }
            return cell
        case DetailMoreLikeCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailMoreLikeCell.cellId) as! DetailMoreLikeCell
            cell.sourceTV = televisionRecommendationVM?.data ?? []
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
        switch listIDTelevisionCell[indexPath.row]{
        case DetailInforCell.cellId:
            return televisionDetailVM?.data == nil ? 0 : DetailInforCell.height
        case DetailIntroduceCell.cellId:
            return televisionDetailVM?.data == nil ? 0 : DetailIntroduceCell.height
        case DetailScenesCell.cellId:
            return (televisionDetailVM?.data == nil || ((televisionDetailVM?.data?.images?.backdrops ?? []).count == 0)) ? 0 : DetailScenesCell.height
        case DetailTrailerCell.cellId:
            return (televisionDetailVM?.data == nil || ((televisionDetailVM?.data?.videos!.results ?? []).count == 0)) ? 0 : DetailTrailerCell.height
        case DetailMoreLikeCell.cellId:
            return televisionRecommendationVM?.data.count == 0 ? 0 : DetailMoreLikeCell.height
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
