import UIKit

class ItemWithRateCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var lbVote: UILabel!
    
    var imageURL: URL! {
        didSet {
            posterImage.sd_setImage(with: imageURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
        }
    }
    
    var vote: String = "" {
        didSet {
            lbVote.text = vote
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
