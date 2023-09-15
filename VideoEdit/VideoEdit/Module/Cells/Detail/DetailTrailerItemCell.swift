import UIKit

class DetailTrailerItemCell: UICollectionViewCell {

    @IBOutlet weak var imageTrailer: PImageView!
    
    var video: Video! {
        didSet {
            if video != nil {
                imageTrailer.sd_setImage(with: video.youtubeThumbnailURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
