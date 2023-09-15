import UIKit

enum CastActingRowType {
    case none
    case top
    case bottom
}

class CastActionItemCell: UITableViewCell {

    static let height: CGFloat = 70
    
    var data: ActingHistory! {
        didSet {
            yearLabel.text = data.yearText
            titleLabel.text = data.title
            characterLabel.labelTwoColor(title: "as ", colorTitle: .init(rgb: 0x8E99AF), detail: data.character, colorDetail: .init(rgb: 0x131927))
        }
    }
    
    var rowType: CastActingRowType = .none {
        didSet {
            switch rowType {
            case .none:
                conTopLineVerticalView.constant = 0
                conBottomLineVerticalView.constant = 0
            case .top:
                conTopLineVerticalView.constant = 16
                conBottomLineVerticalView.constant = 0
            case .bottom:
                conTopLineVerticalView.constant = 0
                conBottomLineVerticalView.constant = Self.height - 16
            }
        }
    }
    
    // MARK: - outlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var lineVerticalView: UIView!
    @IBOutlet weak var conTopLineVerticalView: NSLayoutConstraint!
    @IBOutlet weak var conBottomLineVerticalView: NSLayoutConstraint!
    
    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        dotView.layer.cornerRadius = dotView.frame.size.height / 2
        dotView.clipsToBounds = true
        conTopLineVerticalView.constant = 0 // default
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
