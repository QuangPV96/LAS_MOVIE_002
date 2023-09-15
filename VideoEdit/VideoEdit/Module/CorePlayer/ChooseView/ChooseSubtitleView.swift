//
//  ChooseSubtitleView.swift
//  VideoPlayer
//
//  Created by Quynh Nguyen on 13/06/2022.
//

import UIKit

class ChooseSubtitleView: UIView {
    
    lazy fileprivate var vSubtitlesByLang: [SubtitleModel] = SubtitleService.shared.vSubtitlesByLang
    
    public var onSelectedSub: ((_ sub: SubtitleModel) -> Void)? = nil
    public var onOffsub: (() -> Void)? = nil
    
    // MARK: - properties
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let vSubtitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let onlineSubtitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let vsubtileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Video subtitles"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    fileprivate let vTableview: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "v-subtitle-id")
        table.backgroundColor = .clear
        table.separatorColor = .white.withAlphaComponent(0.4)
        return table
    }()
    
    private let onlinesubtileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Online subtitles"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    fileprivate let onlineTableview: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "online-subtitle-id")
        table.backgroundColor = .clear
        table.separatorColor = .white.withAlphaComponent(0.4)
        return table
    }()
    
    private let offSubButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OFF SUB", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        return button
    }()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        backgroundColor = .black.withAlphaComponent(0.9)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        vTableview.delegate = self
        vTableview.dataSource = self
        
        onlineTableview.delegate = self
        onlineTableview.dataSource = self
        
        cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        offSubButton.addTarget(self, action: #selector(offSubClicked), for: .touchUpInside)
        
        addSubview(stackView)
        addSubview(offSubButton)
        addSubview(cancelButton)
        
        stackView.addArrangedSubview(vSubtitleContainerView)
        stackView.addArrangedSubview(onlineSubtitleContainerView)
        
        vSubtitleContainerView.addSubview(vsubtileLabel)
        vSubtitleContainerView.addSubview(vTableview)
        
        onlineSubtitleContainerView.addSubview(onlinesubtileLabel)
        onlineSubtitleContainerView.addSubview(onlineTableview)
        
        // autolayout
        cancelButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        offSubButton.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -10).isActive = true
        offSubButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        offSubButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        offSubButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -5).isActive = true
        
        vsubtileLabel.topAnchor.constraint(equalTo: vSubtitleContainerView.topAnchor, constant: 0).isActive = true
        vsubtileLabel.leftAnchor.constraint(equalTo: vSubtitleContainerView.leftAnchor, constant: 0).isActive = true
        vsubtileLabel.rightAnchor.constraint(equalTo: vSubtitleContainerView.rightAnchor, constant: 0).isActive = true
        vsubtileLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        vTableview.topAnchor.constraint(equalTo: vsubtileLabel.bottomAnchor, constant: 0).isActive = true
        vTableview.leftAnchor.constraint(equalTo: vSubtitleContainerView.leftAnchor, constant: 0).isActive = true
        vTableview.rightAnchor.constraint(equalTo: vSubtitleContainerView.rightAnchor, constant: 0).isActive = true
        vTableview.bottomAnchor.constraint(equalTo: vSubtitleContainerView.bottomAnchor, constant: 0).isActive = true
        
        onlinesubtileLabel.topAnchor.constraint(equalTo: onlineSubtitleContainerView.topAnchor, constant: 0).isActive = true
        onlinesubtileLabel.leftAnchor.constraint(equalTo: onlineSubtitleContainerView.leftAnchor, constant: 0).isActive = true
        onlinesubtileLabel.rightAnchor.constraint(equalTo: onlineSubtitleContainerView.rightAnchor, constant: 0).isActive = true
        onlinesubtileLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        onlineTableview.topAnchor.constraint(equalTo: onlinesubtileLabel.bottomAnchor, constant: 0).isActive = true
        onlineTableview.leftAnchor.constraint(equalTo: onlineSubtitleContainerView.leftAnchor, constant: 0).isActive = true
        onlineTableview.rightAnchor.constraint(equalTo: onlineSubtitleContainerView.rightAnchor, constant: 0).isActive = true
        onlineTableview.bottomAnchor.constraint(equalTo: onlineSubtitleContainerView.bottomAnchor, constant: 0).isActive = true
        
        NotificationCenter.default.addObserver(forName: .onSubtitles_did_update, object: nil, queue: .main) { [weak self] _ in
            self?.reloadData()
        }
    }
    
    func reloadData() {
        vTableview.reloadData()
        onlineTableview.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            let link = SubtitleService.shared.subtitleSelected?.file ?? ""
            if let index = self?.vSubtitlesByLang.firstIndex(where: { $0.file == link }) {
                let indexPath = IndexPath(item: index, section: 0)
                self?.vTableview.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
            if let index = SubtitleService.shared.onSubtitles.firstIndex(where: { $0.file == link }) {
                let indexPath = IndexPath(item: index, section: 0)
                self?.onlineTableview.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    func show() {
        guard let window = ApplicationHelper.shared.window() else { return }
        
        frame = window.bounds
        alpha = 0
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            self.reloadData()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelClicked(_ sender: Any) {
        dismiss()
    }
    
    @objc func offSubClicked(_ sender: Any) {
        SubtitleService.shared.subtitleSelected = nil
        onOffsub?()
        dismiss()
    }
}

extension ChooseSubtitleView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vTableview == tableView {
            return self.vSubtitlesByLang.count
        }
        else {
            return SubtitleService.shared.onSubtitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = vTableview == tableView ? "v-subtitle-id" : "online-subtitle-id"
        let link = vTableview == tableView ? self.vSubtitlesByLang[indexPath.row].file : SubtitleService.shared.onSubtitles[indexPath.row].file
        let text = vTableview == tableView ? self.vSubtitlesByLang[indexPath.row].label : SubtitleService.shared.onSubtitles[indexPath.row].label
        let isSelected = link == SubtitleService.shared.subtitleSelected?.file
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id)!
        cell.textLabel?.text = text
        cell.textLabel?.textColor = isSelected ? UIColor.orange : UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        var checkImage: UIImageView? = cell.contentView.viewWithTag(2) as? UIImageView
        if checkImage == nil {
            checkImage = UIImageView()
            checkImage?.tag = 2
            checkImage?.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(checkImage!)
            
            checkImage?.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: 0).isActive = true
            checkImage?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
            checkImage?.widthAnchor.constraint(equalToConstant: 21).isActive = true
            checkImage?.heightAnchor.constraint(equalToConstant: 21).isActive = true
        }
        
        checkImage?.image = isSelected ? UIImage.getImage("radio_button_checked") : UIImage.getImage("radio_button_uncheck")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if vTableview == tableView {
            SubtitleService.shared.subtitleSelected = self.vSubtitlesByLang[indexPath.row]
        }
        else {
            SubtitleService.shared.subtitleSelected = SubtitleService.shared.onSubtitles[indexPath.row]
        }
        
        tableView.reloadData()
        self.onSelectedSub?(SubtitleService.shared.subtitleSelected!)
        self.dismiss()
    }
    
}
