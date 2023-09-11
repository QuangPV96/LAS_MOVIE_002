//
//  MyFileCell.swift
//  VideoEdit
//
//  Created by apple on 08/08/2023.
//

import UIKit

class MyFileCell: UITableViewCell {
    @IBOutlet weak var constrantWidthThumb: NSLayoutConstraint!
    
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var ivThumb: UIImageView!
    var itemSelectBlock:((VideoModel, Int) -> Void)!
    var videoModel: VideoModel!
    var indexSelect: Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        if(isPad()) {
            constrantWidthThumb.constant = 200
            lblName.font = lblName.font.withSize(24)
            lblDuration.font = lblDuration.font.withSize(20)
        }
        // Initialization code
    }

    func setData(videoModel: VideoModel, isHideLine: Bool, row: Int) {
        self.videoModel = videoModel
        self.indexSelect = row
        ivThumb.image = videoModel.thumbnail
        lblDuration.text = Constants.format(duration: videoModel.videoDuration)
        lblName.text = videoModel.videoName
        vLine.isHidden = isHideLine
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        if(self.itemSelectBlock != nil) {
            self.itemSelectBlock(videoModel, self.indexSelect)
        }
    }
}
