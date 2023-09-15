import UIKit

class CastDetailCell: UITableViewCell {

    static let height: CGFloat = 200
    
    @IBOutlet weak var castImageView: PImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var desc1Label: UILabel!
    @IBOutlet weak var desc2Label: UILabel!
    @IBOutlet weak var desc3Label: UILabel!
    
    var cast: People! {
        didSet {
            if cast != nil {
                castImageView.sd_setImage(with: cast.profileURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
                nameLabel.text = cast.name
                desc1Label.text = cast.birthdayText
                desc2Label.text = cast.knowForDepartmentText
                desc3Label.text = cast.placeOfBirthText
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
