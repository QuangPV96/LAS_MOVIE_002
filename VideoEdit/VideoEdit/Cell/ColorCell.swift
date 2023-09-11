//
//  ColorCell.swift
//  VideoEdit
//
//  Created by Trung Nguyễn on 11/08/2023.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var vColor: PView!
    @IBOutlet weak var vParent: PView!
    var index = 2
    var itemSelectBlock: ((Int) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(color: Int, row: Int, indexRow: Int) {
        if(indexRow == row) {
            vParent.borderWidth = 1
        }else {
            vParent.borderWidth = 0
        }
        index = row
        vParent.borderColor = UIColor(hex: color)
        vColor.backgroundColor = UIColor(hex: color)
    }

    @IBAction func actionSelect(_ sender: Any) {
        if(itemSelectBlock != nil) {
            itemSelectBlock(index)
        }
    }
}
