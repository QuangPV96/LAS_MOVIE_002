import UIKit

class CustomButtonViewAll: UIView {
    // MARK: - properties
    var dimmedView: UIView!
    
    var onClick: (() -> Void)?
    
    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.size.height / 2
        }
    }
    
    // MARK: - initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    // MARK: - private
    private func setupUI() {
        //frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: 147, height: 44)
        layer.masksToBounds = false
        
        backgroundColor = .clear
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandle(_:))))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpressHandle(_:)))
        longPress.minimumPressDuration = 0.3
        addGestureRecognizer(longPress)
        
        
        // create semi-transparent black view
        dimmedView = UIView()
        dimmedView.backgroundColor = .white
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.layer.cornerRadius = 4.5
        addSubview(dimmedView)
        
        dimmedView.widthAnchor.constraint(equalToConstant: 9).isActive = true
        dimmedView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        dimmedView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        dimmedView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //
        let playImage = UIImageView(image: UIImage(named: "ic_viewall"))
        playImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playImage)
        
        playImage.widthAnchor.constraint(equalToConstant: 3).isActive = true
        playImage.heightAnchor.constraint(equalToConstant: 6).isActive = true
        playImage.rightAnchor.constraint(equalTo: dimmedView.rightAnchor, constant: -3).isActive = true
        playImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View all"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: dimmedView.leftAnchor, constant: -4).isActive = true
       // label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - public
    
    // MARK: - action
    @objc func tapHandle(_ sender: UITapGestureRecognizer) {
        onClick?()
    }
    
    @objc func longpressHandle(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            layer.borderColor = UIColor.red.cgColor
        case .ended:
            layer.borderColor = UIColor.white.cgColor
            onClick?()
        default:
            layer.borderColor = UIColor.white.cgColor
        }
    }
}
