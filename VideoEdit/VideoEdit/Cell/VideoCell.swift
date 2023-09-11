//
//  VideoCell.swift
//  VideoEdit
//
//  Created by apple on 08/08/2023.
//

import UIKit

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var ivSelect: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var isMerge = false {
        didSet {
            var size = 16.0
            if(!isMerge) {
                size = 14.0
            }
            lblDuration.font.withSize(size)
        }
    }
    var itemSelectBlock:((VideoModel, Int) -> Void)!
    var videoModel: VideoModel!
    var indexSelect: Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(videoModel: VideoModel, row: Int) {
        self.videoModel = videoModel
        self.indexSelect = row
        do {
            ivThumb.image = (videoModel.thumbnail != nil) ? videoModel.thumbnail : UIImage(named: "ic_thumb_fake")
            lblDuration.text = Constants.format(duration: videoModel.videoDuration)
            lblName.text = videoModel.videoName
            ivSelect.isHidden = videoModel.isNotSelect
        }catch {}
        
    }
   

    @IBAction func actionSelect(_ sender: Any) {
        if(self.itemSelectBlock != nil) {
            self.itemSelectBlock(videoModel, self.indexSelect)
        }
    }
}
