import UIKit

class CastIntroCell: UITableViewCell, ExpandableLabelDelegate {

    static let height: CGFloat = UITableView.automaticDimension
    
    @IBOutlet weak var overviewLabel: ExpandableLabel!
    
    var isCollapsed: Bool = false {
        didSet {
            overviewLabel.collapsed = isCollapsed
        }
    }
    
    var overview: String! {
        didSet {
            overviewLabel.text = overview
        }
    }
    
    var onChangedState: ((_ collapsed: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overviewLabel.text = ""
        overviewLabel.numberOfLines = 4
        overviewLabel.delegate = self
        overviewLabel.shouldExpand = true
        overviewLabel.shouldCollapse = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x233458),
            NSAttributedString.Key.font: UIFont.fontSemiBold(12)!
        ]
        overviewLabel.collapsedAttributedLink = NSAttributedString(string: "Read all", attributes: attributes)
        overviewLabel.expandedAttributedLink = NSAttributedString(string: "Read less", attributes: attributes)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
        onChangedState?(false)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        onChangedState?(true)
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
}
