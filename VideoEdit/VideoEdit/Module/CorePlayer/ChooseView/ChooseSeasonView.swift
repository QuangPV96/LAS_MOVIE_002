//
//  ChooseSeasonView.swift
//  LASAdvertising
//
//  Created by Quynh Nguyen on 16/06/2022.
//

import UIKit

fileprivate let padding: CGFloat = 10
fileprivate let columns: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 5 : 4

protocol ChooseSeasonDelegate: NSObject {
    func selectSeason(num: Int, episodes: [TelevisionEpisode])
    func selectEpisode(num: Int, episode: TelevisionEpisode)
}

class ChooseSeasonView: UIView {
    fileprivate let api = TVShowAPIService()
    
    public weak var delegate: ChooseSeasonDelegate?
    
    public var idTv: Int = 0
    public var seasons: [TelevisionSeason] = [] {
        didSet { listSeason.reloadData() }
    }
    
    public var episodes: [TelevisionEpisode] = [] {
        didSet { listEpisode.reloadData() }
    }
    
    public var seasonSelected: Int? {
        didSet { listSeason.reloadData() }
    }
    
    public var episodeId: Int = 0 {
        didSet { listEpisode.reloadData() }
    }
    
    //public var onSelected: ((_ season: Int, _ episodes: [TelevisionEpisode]) -> Void)? = nil
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.getImage("baseline_close_white"), for: .normal)
        return button
    }()
    
    private let listSeason: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.alwaysBounceHorizontal = true
        collection.register(CustomizeCell.self, forCellWithReuseIdentifier: "seasonCELL")
        return collection
    }()
    
    private let listEpisode: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.alwaysBounceVertical = true
        collection.register(CustomizeCell.self, forCellWithReuseIdentifier: "epsisodeCELL")
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        clipsToBounds = true
        
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        
        listSeason.delegate = self
        listSeason.dataSource = self
        
        listEpisode.delegate = self
        listEpisode.dataSource = self
        
        addSubview(closeButton)
        addSubview(listSeason)
        addSubview(listEpisode)
        
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        listSeason.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        listSeason.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        listSeason.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: 0).isActive = true
        listSeason.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        listEpisode.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        listEpisode.topAnchor.constraint(equalTo: listSeason.bottomAnchor, constant: 10).isActive = true
        listEpisode.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        listEpisode.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func show() {
        guard let window = ApplicationHelper.shared.window() else { return }
        
        frame = window.bounds
        alpha = 0
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            //self.reloadData()
        }
    }
    
    @objc func closeClicked() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

extension ChooseSeasonView: UICollectionViewDelegate, UICollectionViewDataSource {
    private func seasonCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCELL", for: indexPath) as! CustomizeCell
        cell.layer.cornerRadius = collectionView.frame.size.height / 2
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        
        var label = cell.contentView.viewWithTag(1) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = 1
            label?.translatesAutoresizingMaskIntoConstraints = false
            label?.font = UIFont.systemFont(ofSize: 14)
            label?.textColor = .white
            label?.textAlignment = .center
            cell.contentView.addSubview(label!)
            
            label?.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            label?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            label?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            label?.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        }
        
        let season = seasons[indexPath.row].season_number ?? 0
        label?.text = "Season \(season)"
        if season == (seasonSelected ?? 0) {
            cell.backgroundColor = UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        }
        
        return cell
    }
    
    private func episodeCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "epsisodeCELL", for: indexPath) as! CustomizeCell
        
        var image = cell.contentView.viewWithTag(1) as? UIImageView
        if image == nil {
            image = UIImageView()
            image?.translatesAutoresizingMaskIntoConstraints = false
            image?.tag = 1
            image?.backgroundColor = .gray
            image?.layer.masksToBounds = true
            cell.contentView.addSubview(image!)
            
            image?.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            image?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            image?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            
            let w: CGFloat = ((collectionView.frame.size.width - (columns + 1) * padding) / columns).rounded(.down)
            image?.heightAnchor.constraint(equalToConstant: w / 2.0).isActive = true
        }
        image?.image = nil
        if let backdropURL = episodes[indexPath.row].backdropURL {
            image?.downloaded(from: backdropURL, contentMode: .scaleAspectFill  )
        }
        
        var epiLabel = cell.contentView.viewWithTag(2) as? UILabel
        if epiLabel == nil {
            epiLabel = UILabel()
            epiLabel?.translatesAutoresizingMaskIntoConstraints = false
            epiLabel?.tag = 2
            epiLabel?.font = UIFont.systemFont(ofSize: 14)
            epiLabel?.textColor = .white
            epiLabel?.numberOfLines = 1
            cell.contentView.addSubview(epiLabel!)
            
            epiLabel?.topAnchor.constraint(equalTo: image!.bottomAnchor).isActive = true
            epiLabel?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            epiLabel?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            epiLabel?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        epiLabel?.text = "Episode \(episodes[indexPath.row].episode_number ?? 0)"
        
        var lineView = cell.contentView.viewWithTag(3)
        if lineView == nil {
            lineView = UIView()
            lineView?.translatesAutoresizingMaskIntoConstraints = false
            lineView?.tag = 3
            lineView?.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            cell.contentView.addSubview(lineView!)
            
            lineView?.topAnchor.constraint(equalTo: epiLabel!.bottomAnchor).isActive = true
            lineView?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            lineView?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            lineView?.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        }
        lineView?.backgroundColor = episodes[indexPath.row].id == episodeId ? UIColor.orange : UIColor.white.withAlphaComponent(0.4)
        
        var dateLabel = cell.contentView.viewWithTag(4) as? UILabel
        if dateLabel == nil {
            dateLabel = UILabel()
            dateLabel?.translatesAutoresizingMaskIntoConstraints = false
            dateLabel?.tag = 4
            dateLabel?.font = UIFont.systemFont(ofSize: 12)
            dateLabel?.textColor = .white.withAlphaComponent(0.7)
            dateLabel?.numberOfLines = 1
            cell.contentView.addSubview(dateLabel!)
            
            dateLabel?.topAnchor.constraint(equalTo: lineView!.bottomAnchor).isActive = true
            dateLabel?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            dateLabel?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            dateLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        dateLabel?.text = episodes[indexPath.row].airDateText
        
        var infoLabel = cell.contentView.viewWithTag(5) as? UILabel
        if infoLabel == nil {
            infoLabel = UILabel()
            infoLabel?.translatesAutoresizingMaskIntoConstraints = false
            infoLabel?.tag = 5
            infoLabel?.font = UIFont.systemFont(ofSize: 14)
            infoLabel?.textColor = .white.withAlphaComponent(0.85)
            infoLabel?.numberOfLines = 0
            cell.contentView.addSubview(infoLabel!)
            
            infoLabel?.topAnchor.constraint(equalTo: dateLabel!.bottomAnchor).isActive = true
            infoLabel?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            infoLabel?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            infoLabel?.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        }
        infoLabel?.text = episodes[indexPath.row].overview ?? ""
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listSeason {
            return seasons.count
        }
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listSeason {
            return seasonCell(collectionView, cellForItemAt: indexPath)
        }
        else {
            return episodeCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listSeason {
            seasonSelected = seasons[indexPath.row].season_number ?? 0
            episodes = []
            
            showUniversalLoadingView(true)
            api.fetchSeasonDetail(tvId: self.idTv, seasonNumber: seasonSelected!) { [weak self] result in
                showUniversalLoadingView(false)
                
                guard let self = self else { return }
                switch result {
                case .success(let tmp):
                    self.episodes = tmp.episodes ?? []
                case .failure(let er):
                    break
                }
                self.delegate?.selectSeason(num: self.seasonSelected!, episodes: self.episodes)
            }
        }
        else {
            let epi = episodes[indexPath.row]
            self.delegate?.selectEpisode(num: epi.episode_number ?? 0, episode: epi)
        }
    }
}

extension ChooseSeasonView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listSeason {
            return CGSize(width: 110, height: collectionView.frame.size.height)
        }
        else {
            let w: CGFloat = ((collectionView.frame.size.width - (columns + 1) * padding) / columns).rounded(.down)
            let h: CGFloat = w * 1.1
            return CGSize(width: w, height: h)
        }
    }
}

class CustomizeCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet { bounce(isHighlighted) }
    }
    
    func bounce(_ bounce: Bool) {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.transform = bounce ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity },
            completion: nil)
        
    }
}
