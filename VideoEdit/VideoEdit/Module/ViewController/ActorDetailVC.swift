import UIKit

class ActorDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var actorId: Int = 0
    var cast: Cast?
    fileprivate let listIDCastCell: [String] = [
        CastDetailCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        CastIntroCell.cellId,
        CastKnowForCell.cellId,
        CastActionCell.cellId
    ]
    
    fileprivate var collapsedOverviewPeople: Bool = true
    fileprivate var collapsedOverviewActing: Bool = true
    
    fileprivate var peopleDetailVM: PeopleDetailVM?
    fileprivate var peopleCreditVM: PeopleCreditVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CastDetailCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastDetailCell.cellId)
        tableView.register(UINib(nibName: CastIntroCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastIntroCell.cellId)
        tableView.register(UINib(nibName: CastKnowForCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastKnowForCell.cellId)
        tableView.register(UINib(nibName: CastActionCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastActionCell.cellId)
        tableView.registerItem(cell: AdmobNativeAdTableCell.self)
        tableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.peopleDetailVM = PeopleDetailVM(id: actorId)
        self.peopleDetailVM?.bindViewModelToController = {
            self.tableView.reloadData()
            let item = self.peopleDetailVM!.data!
            self.cast = Cast(id: item.id, character: item.biography!, name: item.name, known_for_department: item.known_for_department, profile_path: item.profile_path)
        }
        self.peopleDetailVM?.loadData()
        
        self.peopleCreditVM = PeopleCreditVM(id: actorId)
        self.peopleCreditVM?.bindViewModelToController = {
            self.tableView.reloadData()
        }
        self.peopleCreditVM?.loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.tableView.reloadData()
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
        return listIDCastCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (listIDCastCell[indexPath.row]){
        case CastDetailCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastDetailCell.cellId) as! CastDetailCell
            cell.cast = peopleDetailVM?.data
            return cell
        case CastIntroCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.cellId) as! CastIntroCell
            cell.isCollapsed = collapsedOverviewPeople
            cell.onChangedState = { collapsed in
                self.collapsedOverviewPeople = collapsed
                self.tableView.reloadData()
            }
            cell.overview = not_available
            if peopleDetailVM?.data != nil {
                cell.overview = peopleDetailVM?.data!.biography ?? not_available
            }
            return cell
        case CastKnowForCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastKnowForCell.cellId) as! CastKnowForCell
            cell.source = peopleCreditVM?.data ?? []
            cell.selectItemBlock = { item in
                if let movie = item as? Movie {
                    self.openDetail(movie)
                }
                else if let tele = item as? Television {
                    self.openDetail(tele)
                }
            }
            return cell
        case CastActionCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastActionCell.cellId) as! CastActionCell
            cell.actings = peopleCreditVM?.actings ?? []
            cell.isCollapsed = self.collapsedOverviewActing
            cell.onChangedState = {
                self.collapsedOverviewActing = !self.collapsedOverviewActing
                self.tableView.reloadData()
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
        switch (listIDCastCell[indexPath.row]){
        case CastDetailCell.cellId:
            return peopleDetailVM?.data == nil ? 0 : CastDetailCell.height
        case CastIntroCell.cellId:
            return CastIntroCell.height
        case CastKnowForCell.cellId:
            return peopleCreditVM?.data == nil ? 0 : CastKnowForCell.height
        case CastActionCell.cellId:
            if peopleCreditVM == nil || peopleCreditVM?.actings == nil || peopleCreditVM?.actings.count == 0 {
                return 0
            } else {
                if collapsedOverviewActing == true {
                    return peopleCreditVM!.actings.count > 7 ? 560 : CGFloat(peopleCreditVM!.actings.count * 70 + 70)
                } else {
                    return CGFloat(peopleCreditVM!.actings.count) * 70 + 70
                }
            }
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
