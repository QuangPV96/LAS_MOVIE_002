import UIKit
import SDWebImage

class ImageItemCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    
    var imageURL: URL! {
        didSet {
            posterImage.sd_setImage(with: imageURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
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
