import UIKit

class ItemWithIndexCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var indexImage: UIImageView!
    
    var imageURL: URL! {
        didSet {
            posterImage.sd_setImage(with: imageURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
        }
    }
    
    var index: Int = 0 {
        didSet {
            if (index > 4) {
                indexImage.isHidden = true
            } else {
                indexImage.isHidden = false
                indexImage.image = .original("ic_index\(index+1)")
            }
        }
    }
    
    var cornerImage: Int = 16 {
        didSet {
            posterImage.layer.cornerRadius = CGFloat(cornerImage)
            posterImage.clipsToBounds = true
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
