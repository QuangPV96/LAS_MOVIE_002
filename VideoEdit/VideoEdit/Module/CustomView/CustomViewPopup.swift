import UIKit
import SwiftMessages

class CustomViewPopup: UIView {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var lbCancel: UILabel!
    @IBOutlet weak var lbOk: UILabel!
    @IBOutlet weak var viewContent: PView!
    
    var blockCancel: (() -> ())?
    var blockAccept: (() -> ())?
    
    var titleString: String = "" {
        didSet {
            lbTitle.text = titleString
        }
    }
    var contentString: String = "" {
        didSet {
            lbContent.text = contentString
        }
    }
    
    var textAccept: String = "" {
        didSet {
            lbOk.text = textAccept
        }
    }
    var textCancel: String = "" {
        didSet {
            lbCancel.text = textCancel
            if textCancel == "" {
                viewCancel.isHidden = true
            } else {
                viewCancel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionCanel(_ sender: Any) {
        SwiftMessages.hideAll()
        if self.blockCancel != nil {
            self.blockCancel!()
        }
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        if self.blockAccept != nil {
            self.blockAccept!()
        }
        SwiftMessages.hideAll()
    }
    
    deinit {
        
    }
    
    static func show(titleString: String, contentString: String,textAccept: String, textCancel: String, blockAccept: @escaping (() -> ()), blockCancel: @escaping (() -> ())) {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .forever
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.6), interactive: true)
        config.interactiveHide = true
        if #available(iOS 13.0, *) {
            config.preferredStatusBarStyle = .darkContent
        }
        config.presentationContext = .window(windowLevel: .normal)
        
        let view: CustomViewPopup = try! SwiftMessages.viewFromNib()
        view.titleString = titleString
        view.contentString = contentString
        view.textAccept = textAccept
        view.textCancel = textCancel
        view.blockAccept = blockAccept
        view.blockCancel = blockCancel
        SwiftMessages.sharedInstance.show(config: config, view: view)
    }
    
    static func show(titleString: String, contentString: String,textAccept: String, textCancel: String, interactiveHide : Bool, blockAccept: @escaping (() -> ()), blockCancel: @escaping (() -> ())) {
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.6), interactive: interactiveHide)
        config.interactiveHide = interactiveHide
        if #available(iOS 13.0, *) {
            config.preferredStatusBarStyle = .darkContent
        }
        
        config.presentationContext = .window(windowLevel: .normal)
        
        let view: CustomViewPopup = try! SwiftMessages.viewFromNib()
        view.titleString = titleString
        view.contentString = contentString
        view.textAccept = textAccept
        view.textCancel = textCancel
        view.blockAccept = blockAccept
        view.blockCancel = blockCancel
        SwiftMessages.sharedInstance.show(config: config, view: view)
    }

}
