//
//  FolderCell.swift
//  VideoEdit
//
//  Created by apple on 13/08/2023.
//

import UIKit

class FolderCell: UITableViewCell {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblNameFolder: UILabel!
    var itemSelectBlock: ((Folder) -> Void)!
    var folder: Folder!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(folder: Folder) {
        self.folder = folder
        lblNameFolder.text = folder.name
        lblCount.text = folder.count
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        if(itemSelectBlock != nil) {
            self.itemSelectBlock(self.folder)
        }
    }
}
