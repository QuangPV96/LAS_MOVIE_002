import UIKit
import SDWebImage

class DetailSesonItemCell: UITableViewCell {

    @IBOutlet weak var imageThumb: PImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    
    var selectEpisode: ((_ episodes: TelevisionEpisode) -> Void)?
    
    var episode: TelevisionEpisode? {
        didSet {
            if episode?.still_path != "" {
                imageThumb.sd_setImage(with: UtilService.makeURLImage(episode?.still_path), placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
            }
            lbTitle.text = "Episode \(episode?.episode_number ?? 0)"
            lbDate.text = episode?.airDateText
            lbContent.text = episode?.overview
        }
    }
    
    var backdrop: URL? {
        didSet {
            imageThumb.sd_setImage(with: backdrop, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectCell(_ sender: Any) {
        if let selectEpisode = self.selectEpisode {
            selectEpisode(episode!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
