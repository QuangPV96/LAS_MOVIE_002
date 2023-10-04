//
//  SettingCell.swift
//  DetizLoca
//
//  Created by Tuan.SuKA on 18/03/2022.
//

import UIKit

enum SettingType: String {
    case notification, policy, feedback, share, rate
    
    func title() -> String {
        switch self {
        case .notification: return "Notification"
        case .policy: return "Policy"
        case .feedback: return "Feedback"
        case .share: return "Share app"
        case .rate: return "Rate app"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .notification: return "ic_notification"
        case .policy: return "ic_policy_root"
        case .feedback: return "ic_feedback_root"
        case .share: return "ic_share_root"
        case .rate: return "ic_star_toprated"
        }
    }
}
class SettingCell: UICollectionViewCell {
    
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var settingMore: UIImageView!
    
    var onChangedState: ((_ switchState: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.fontReular(18)
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if self.settingSwitch.isOn {
            onChangedState?(true)
        }
        else {
            onChangedState?(false)
        }
    }
    
    var type: SettingType = .notification {
        didSet {
            settingImage.image = UIImage(named: type.imageName())
            nameLabel.text = type.title()
            
            switch type {
            case .notification:
                settingMore.isHidden = true
                settingSwitch.isHidden = false
                settingSwitch.isOn = UserDefaults.standard.bool(forKey: type.rawValue)
            default:
                settingMore.isHidden = false
                settingSwitch.isHidden = true
            }
        }
    }

}
