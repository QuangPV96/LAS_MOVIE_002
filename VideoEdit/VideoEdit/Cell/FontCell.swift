//
//  FontCell.swift
//  VideoEdit
//
//  Created by apple on 12/08/2023.
//

import UIKit

class FontCell: UICollectionViewCell {
    @IBOutlet weak var lblFont: UILabel!
    @IBOutlet weak var vParent: PView!
    var itemSelect = 0
    var selectItemBlock :((Int) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(item: String, row: Int, itemSelect: Int) {
        if(itemSelect == row) {
            vParent.backgroundColor = .white
            lblFont.textColor = UIColor(hex: 0x4E59FF)
        }else {
            vParent.backgroundColor = UIColor(hex: "#000000", alpha: 0.36)
            lblFont.textColor = .white
        }
        self.itemSelect = row
        lblFont.font = UIFont(name: item, size: 20)
    }

    @IBAction func actionSelect(_ sender: Any) {
        if(selectItemBlock != nil) {
            self.selectItemBlock(self.itemSelect)
        }
    }
}
