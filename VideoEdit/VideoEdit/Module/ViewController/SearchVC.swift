import UIKit
import Lottie

class SearchVC: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewAnimation: UIView!
    
    //MARK: -properties
    fileprivate let listIDCell: [String] = [
        SearchMovieCell.cellId,
        AdmobNativeAdCell.cellId,
        AppLovinNativeAdCell.cellId,
        SearchTvShowCell.cellId,
        SearchActorCell.cellId
    ]
    var textSearch: String?
    
    //MARK: -view model
    fileprivate var movieVM: SearchMovieVM?
    fileprivate var tvShowVM: SearchTelevisionVM?
    fileprivate var peopleVM: SearchPeopleVM?
    
    var animationView: LottieAnimationView = LottieAnimationView(name: "animation_empty")
    
    //MARK: -outlets
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.roundTopLeftRight(radius: 20, color: .shadow, offset: .init(width: 0, height: -4))
        
        searchCollectionView.register(UINib(nibName: SearchMovieCell.cellId, bundle: nil),
                                      forCellWithReuseIdentifier: SearchMovieCell.cellId)
        searchCollectionView.register(UINib(nibName: SearchTvShowCell.cellId, bundle: nil), forCellWithReuseIdentifier: SearchTvShowCell.cellId)
        searchCollectionView.register(UINib(nibName: SearchActorCell.cellId, bundle: nil), forCellWithReuseIdentifier: SearchActorCell.cellId)
        searchCollectionView.registerItem(cell: AdmobNativeAdCell.self)
        searchCollectionView.registerItem(cell: AppLovinNativeAdCell.self)
        
        searchTextField.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.reloadData()
        
        if textSearch != nil {
            searchTextField.text = textSearch
            searchLabel.text = "Result for \"" + textSearch! + "\""
            startSearch()
            viewAnimation.isHidden = true
        } else {
            viewAnimation.isHidden = false
        }
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        self.viewAnimation.addSubview(animationView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.searchCollectionView.reloadData()
            }
        }
        self.animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationView.stop()
    }
    
    // MARK: - request api
    fileprivate func startSearch() {
        let term = searchTextField.text!.trimming()
        if term.isEmpty {
            self.searchLabel.text = "Search"
            self.viewAnimation.isHidden = false
        } else {
            self.searchLabel.text = "Result for \"" + term + "\""
            self.viewAnimation.isHidden = true
        }
        self.searchCollectionView.setContentOffset(.zero, animated: false)
        
        movieVM = SearchMovieVM(term: term)
        movieVM?.bindViewModelToController = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        movieVM?.loadData()
        
        tvShowVM = SearchTelevisionVM(term: term)
        tvShowVM?.bindViewModelToController = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        tvShowVM?.loadData()
        
        peopleVM = SearchPeopleVM(term: term)
        peopleVM?.bindViewModelToController = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        peopleVM?.loadData()
    }
    
    func checkEmpty(){
        if (movieVM?.data ?? []).count == 0 && (tvShowVM?.data ?? []).count == 0 && (peopleVM?.data ?? []).count == 0 {
            self.viewAnimation.isHidden = false
        } else {
            self.viewAnimation.isHidden = true
        }
    }
    
    @IBAction func backHandle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listIDCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listIDCell[indexPath.row] {
        case SearchMovieCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.cellId, for: indexPath) as! SearchMovieCell
            cell.source = movieVM?.data ?? []
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            return cell
        case SearchTvShowCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTvShowCell.cellId, for: indexPath) as! SearchTvShowCell
            cell.source = tvShowVM?.data ?? []
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            return cell
        case SearchActorCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchActorCell.cellId, for: indexPath) as! SearchActorCell
            cell.source = peopleVM?.data ?? []
            cell.selectItemBlock = { item in
                self.openActorDetail(item.id)
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
        case SearchMovieCell.cellId:
            h = (movieVM?.data ?? []).count == 0 ? 0 : SearchMovieCell.height
        case SearchTvShowCell.cellId:
            h = (tvShowVM?.data ?? []).count == 0 ? 0 :SearchTvShowCell.height
        case SearchActorCell.cellId:
            h = (peopleVM?.data ?? []).count == 0 ? 0 :SearchActorCell.height
        case AdmobNativeAdCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.admobAd != nil {
                    if (movieVM?.data ?? []).count == 0 && (tvShowVM?.data ?? []).count == 0 && (peopleVM?.data ?? []).count == 0 {
                        h = 0
                    } else {
                        h = AdmobNativeAdCell.height
                    }
                }
            }
        case AppLovinNativeAdCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.applovinAdView != nil {
                    if (movieVM?.data ?? []).count == 0 && (tvShowVM?.data ?? []).count == 0 && (peopleVM?.data ?? []).count == 0 {
                        h = 0
                    } else {
                        h = AppLovinNativeAdCell.height
                    }
                }
            }
        default:
            h = 0
        }
        return .init(width: UIScreen.main.bounds.size.width, height: h)
    }
    
}

// MARK: - public
extension SearchVC { }

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch()
        return true
    }
}
