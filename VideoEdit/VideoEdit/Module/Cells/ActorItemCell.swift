import UIKit
import SDWebImage

class ActorItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var people: People? {
        didSet {
            posterImage.sd_setImage(with: people?.profileURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
            nameLabel.text = people?.name
            nameLabel.textColor = .white
        }
    }
    
    var imageURL: URL! {
        didSet {
            posterImage.sd_setImage(with: imageURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
        }
    }
    var title: String = "" {
        didSet  {
            nameLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        posterImage.setImageBackground()
        posterImage.layer.cornerRadius = 16
        posterImage.clipsToBounds = true
    }

}
