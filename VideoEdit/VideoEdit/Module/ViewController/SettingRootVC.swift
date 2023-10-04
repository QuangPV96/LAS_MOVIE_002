import UIKit

class SettingRootVC: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    //MARK: -properties
    let settingList: [SettingType] = [.rate, .policy, .feedback, .share]
    
    //MARK: -outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.roundTopLeftRight(radius: 20)
        settingCollectionView.register(UINib(nibName: SettingCell.cellId, bundle: nil), forCellWithReuseIdentifier: SettingCell.cellId)
        settingCollectionView.delegate = self
        settingCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        settingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.cellId, for: indexPath) as! SettingCell
        cell.type = settingList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            switch self.settingList[indexPath.row] {
            case .rate:
                UtilService.openRateApp()
            case .policy:
                UtilService.openURL(URL(string: AppSetting.privacy)!, controller: self)
            case .feedback:
                UtilService().writeEmail(controller: self)
            case .share:
                guard let url = URL(string: "https://apps.apple.com/us/app/id\(AppSetting.id)") else { return }
                let objectsToShare: [Any] = ["", url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.size.width
        let h: CGFloat = 60
        return .init(width: w, height: h)
    }
}
