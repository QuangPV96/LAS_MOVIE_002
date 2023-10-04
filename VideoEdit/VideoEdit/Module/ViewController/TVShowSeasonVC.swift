import UIKit

class TVShowSeasonVC: BaseVC {
    // MARK: - properties
    fileprivate let listIDSeasonsCell: [String] = [
        DetailListSesonCell.cellId,
        DetailSesonCell.cellId
    ]
    
    fileprivate var sesonSelect: TelevisionSeason?
    fileprivate var tvDetailVM: TVDetailVM?
    var tvId: Int = 0
    var name: String = ""
    var television: Television?
    var seasons: [TelevisionSeason] = []
    var seaEspisode: [Int: [TelevisionEpisode]] = [:]
    
    // MARK: - view model
    
    
    // MARK: - outlets
    @IBOutlet weak var mtableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate var seasonDetailVM: TelevisionSeasonDetailVM!
    
    // MARK: - life cycle viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        mtableView.register(UINib(nibName: DetailListSesonCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailListSesonCell.cellId)
        mtableView.register(UINib(nibName: DetailSesonCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailSesonCell.cellId)
        
        self.sesonSelect = seasons[0]
        
        self.seasonDetailVM = TelevisionSeasonDetailVM(tvId: tvId, seasonNumber: (self.sesonSelect?.season_number)!)
        self.seasonDetailVM?.bindViewModelToController = {
            self.mtableView.reloadData()
        }
        seasonDetailVM?.loadData()
        tvDetailVM = TVDetailVM(id: tvId)
        tvDetailVM?.loadData()
        titleLabel.text = television?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: action
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TVShowSeasonVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch listIDSeasonsCell[indexPath.row] {
        case DetailListSesonCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailListSesonCell.cellId) as! DetailListSesonCell
            cell.source = seasons
            cell.sesonSelect = self.sesonSelect
            cell.selectSeason = { [self] season in
                showUniversalLoadingView(true, loadingText: "Please wait...")
                self.sesonSelect = season
                self.seasonDetailVM = TelevisionSeasonDetailVM(tvId: tvId, seasonNumber: self.sesonSelect!.season_number!)
                self.seasonDetailVM?.bindViewModelToController = {
                    self.mtableView.reloadData()
                    showUniversalLoadingView(false)
                }
                self.seasonDetailVM?.loadData()
                self.mtableView.reloadData()
            }
            return cell
        case DetailSesonCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailSesonCell.cellId) as! DetailSesonCell
            cell.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
            cell.backdrop = television!.backdropURL
            cell.selectEpisode = { episode in
                self.selectEpisode(episode)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch listIDSeasonsCell[indexPath.row] {
        case DetailListSesonCell.cellId:
            return DetailListSesonCell.height
        case DetailSesonCell.cellId:
            return self.seasonDetailVM!.data == nil ? 0 : (self.seasonDetailVM!.data!.episodes?.count == 0 ? 0 : CGFloat(self.seasonDetailVM!.data!.episodes!.count*94 + 16))
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func selectEpisode(_ episode: TelevisionEpisode) {
        self.watchTVShow(episode)
    }
    
    private func watchTVShow(_ episode: TelevisionEpisode){
        guard let season = self.sesonSelect,
              let detail = self.tvDetailVM,
              let data = television,
              let externalIds = detail.externalIds else { return }
        
        let name = data.name
        let ss = season.season_number ?? 0
        let epi = episode.episode_number ?? 0
        let imdb = externalIds.imdb_id ?? ""
        
        NetworkHelper.shared.loadT(name, season: ss, episode: epi, imdb: imdb) { [weak self] data in
            guard let self = self else { return }
            
            if data.count == 0 {
                self.alertNotLink {
                    NetworkHelper.shared.rport(name: "[S\(ss)E\(epi)] \(name)",
                                               type: MediaType.tv.rawValue,
                                               year: 0,
                                               imdb: imdb,
                                               content: emptylink)
                }
            
                return
            }
            
            self.loadView.show()
            AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
                let player = ZemPlayerController.makeController()
                player.type = .tv
                player.name = name
                player.tvId = self.tvId
                player.data = data
                player.imdbid = imdb
                player.season = ss
                player.episode = episode
                player.seasons = self.seasons
                player.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
                self.present(player, animated: true)
            }
        }
    }
    
}
