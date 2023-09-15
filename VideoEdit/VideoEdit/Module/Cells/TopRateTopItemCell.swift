import UIKit
import SDWebImage

class TopRateTopItemCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var indexImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var releaseTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            posterImage.sd_setImage(with: movie!.posterURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
            titleLabel.text = movie!.title
            genresLabel.text = movie!.genreText
            releaseLabel.text = movie!.releaseText
            releaseTitleLabel.text = "Release Date: "
            rateLabel.text = movie!.voteAverageText
        }
    }
    
    var television: Television? {
        didSet {
            posterImage.sd_setImage(with: television!.posterURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
            titleLabel.text = television!.name
            genresLabel.text = television!.genreText
            releaseLabel.text = "\(television!.seasonList.count)"
            releaseTitleLabel.text = "Total Seasons: "
            rateLabel.text = television!.voteAverageText
        }
    }
    
    var index: Int = 0 {
        didSet {
            if (index > 10) {
                indexImage.isHidden = true
            } else {
                indexImage.isHidden = false
                indexImage.image = .original("ic_index\(index+1)")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.setImageBackground()
        posterImage.layer.cornerRadius = 6
        posterImage.clipsToBounds = true
    }

}
