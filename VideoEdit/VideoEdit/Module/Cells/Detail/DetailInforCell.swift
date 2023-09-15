import UIKit

class DetailInforCell: UITableViewCell {

    static let height: CGFloat = 530
    
    var movie: Movie? {
        didSet {
            if movie != nil {
                posterImage.sd_setImage(with: movie!.posterURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = movie!.title
                releaseLabel.text = movie!.release_date
                genresLabel.text = movie!.genreText
                lengthLabel.text = movie!.durationText
                rateLabel.text = movie!.ratingText
            }
        }
    }
    
    var television: Television? {
        didSet {
            if television != nil {
                posterImage.sd_setImage(with: television!.posterURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = television!.name
                releaseLabel.text = television!.firstYearText
                genresLabel.text = television!.genreText
                lengthLabel.text = "\(television!.seasonList.count) Seasons"
                rateLabel.text = television!.ratingText
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var posterImage: PImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
