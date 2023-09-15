import UIKit

class ListActorVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: -
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var peopleListVM: PeopleListVM = PeopleListVM()
    var listData: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        collectionView.registerItem(cell: AdmobNativeAdCell.self)
        collectionView.registerItem(cell: AppLovinNativeAdCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        peopleListVM.bindViewModelToController = {
            self.collectionView.reloadData()
            self.collectionView.cr.endLoadingMore()
        }
        peopleListVM.loadData()
        
        collectionView.cr.addFootRefresh {
            if self.peopleListVM.isLoading { return }
            self.peopleListVM.loadData()
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
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.peopleListVM.getSizeData() + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {

        } else if indexPath.row == 1 {

        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            self.openActorDetail(self.peopleListVM.data[indexPath.row - 2].id)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
            cell.people = self.peopleListVM.data[indexPath.row - 2]
            return cell
        }
    }
}

