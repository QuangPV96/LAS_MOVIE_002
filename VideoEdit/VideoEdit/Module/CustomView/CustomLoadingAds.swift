import UIKit

class CustomLoadingAds: UIView {
    // MARK: - properties
    fileprivate let loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .white)
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
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
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(loadingView)
        
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    // MARK: - public
    func present() {
        guard let window = UIWindow.keyWindow else { return }
        
        self.alpha = 0
        self.frame = window.bounds
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        } completion: { _ in
            self.loadingView.startAnimating()
        }
    }
    
    func close(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { _ in
            self.loadingView.stopAnimating()
            let sp = self.superview
            self.removeFromSuperview()
            sp?.removeFromSuperview()
            completion()
        }
    }
    
    // MARK: - action
}
