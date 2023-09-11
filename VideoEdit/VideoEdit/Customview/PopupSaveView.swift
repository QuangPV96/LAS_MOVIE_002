//
//  PopupSaveView.swift
//  RingtoneWallpaper
//
//  Created by apple on 16/08/2023.
//

import Foundation
import UIKit
protocol PopupSaveDelegate {
    func cancel()
    func save(txt: String)
}
class PopupSaveView: UIView {
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName: UITextField!
    var delegate: PopupSaveDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        let nib = UINib(nibName: "PopupSaveView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            
        }
    }
    @IBAction func actionCancel(_ sender: Any) {
        if(delegate != nil) {
            delegate?.cancel()
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        var txt = lblName.text!
        if(txt == "") {
            txt = "noName_\(Date().timeIntervalSince1970).mp4"
        }else {
            txt = txt + ".mp4"
        }

        if(delegate != nil) {
            delegate?.save(txt: txt)
        }
    }
}
