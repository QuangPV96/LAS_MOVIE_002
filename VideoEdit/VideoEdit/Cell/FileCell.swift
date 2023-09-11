//
//  FileCell.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 20/04/2023.
//

import UIKit
import BoxSDK

class FileCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var imageState: PImageView!
    
    var selectCell: SelectCell?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickCell(_ sender: Any) {
        if let selectCell = self.selectCell {
            selectCell.selectCell(index: self.index)
        }
    }
    
    func setData(file: File, selectCell: SelectCell, index: Int) {
        self.selectCell = selectCell
        self.index = index
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy at HH:mm a"
        self.lbName.text = file.name
        self.lbDuration.text = String(format: "Date Modified %@", formatter.string(from: file.modifiedAt ?? Date()))
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(file.name!)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            imageState.image = UIImage(named: "ic_downloaded")
            imageState.tintColorImage = UIColor(hex: 0x545EFF)
        } else {
            imageState.image = UIImage(named: "ic_download")
        }
    }
}
