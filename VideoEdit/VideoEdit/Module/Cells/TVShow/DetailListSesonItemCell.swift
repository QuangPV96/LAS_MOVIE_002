import UIKit

class DetailListSesonItemCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: PView!
    @IBOutlet weak var lbNameSeson: UILabel!
    
    var season: TelevisionSeason? {
        didSet {
            lbNameSeson.text = season?.name
        }
    }
    
    var isCurrent: Bool = false {
        didSet {
            if isCurrent == true {
                viewBg.backgroundColor = .init(rgb: 0xFFC72A)
                lbNameSeson.textColor = .white
            } else {
                viewBg.backgroundColor = .init(rgb: 0xC2C7D1)
                lbNameSeson.textColor = .init(rgb: 0x9AA2B3)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
