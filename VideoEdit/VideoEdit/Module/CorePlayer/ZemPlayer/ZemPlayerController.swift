//
//  ZemPlayerController.swift
//  VideoPlayer
//
//  Created by Quynh Nguyen on 10/06/2022.
//

import UIKit
import AVFoundation

open class ZemPlayerController: UIViewController {
    
    fileprivate var source: [VideoIntentModel] = []
    fileprivate var timer: Timer?
    fileprivate var needResumeTimer: Bool = false
    fileprivate var sceneService: SubsceneHelper?
    
    // MARK: - Properties
    public var type: MediaType = .movie
    public var data: [LASDictionary] = []
    public var name: String = ""
    public var imdbid: String = ""
    public var year: Int = 0
    
    public var tvId: Int?
    public var season: Int?
    internal var episode: TelevisionEpisode?
    internal var seasons: [TelevisionSeason] = []
    internal var episodes: [TelevisionEpisode] = []
    let loadView = PALoadingView()
    lazy var svView: ChooseServerView = {
        let selView = ChooseServerView()
        return selView
    }()
    
    lazy var seasonView: ChooseSeasonView = {
        let selView = ChooseSeasonView()
        return selView
    }()
    
    lazy var langView: ChooseLanguageView = {
        let selView = ChooseLanguageView()
        return selView
    }()
    
    public static func makeController() -> ZemPlayerController {
        let bundle = Bundle(for: Self.self)
        let playerTrailer = ZemPlayerController(nibName: "ZemController", bundle: bundle)
        playerTrailer.modalPresentationStyle = .fullScreen
        return playerTrailer
    }
    
    // MARK: - Outlets
    @IBOutlet weak var playerView: ZemPlayerView!
    @IBOutlet weak var controls: ZemPlayerControls!
    
    // MARK: - Config screen present landscape
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ViewController life-cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.loadView.setMessage("Loading ads...")
        prepareData()
        setupProperties()
        updateTitle()
        setupUI()
        findOpenSubtitle()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        // play first url
        if let s = source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
            let item = ZemPlayerItem(url: url)
            playerView.set(item: item)
            
            SubtitleService.shared.vSubtitles = s.tracks
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimer()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private
    private func setupTimer() {
        let interval = TimeInterval(5)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(triggerTimer),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    private func prepareData() {
        source.removeAll()
        for item in data {
            if let _sources = item["sources"] as? [LASDictionary] {
                
                var sourcesNew: [FileSVModel] = []
                for j in _sources {
                    sourcesNew.append(FileSVModel.createInstance(j))
                }
                
                var tracksNew: [SubtitleModel] = []
                if let _tracks = item["tracks"] as? [LASDictionary] {
                    for j in _tracks {
                        let sub = SubtitleModel.createInstance(j)
                        if sub.label.contains(ChooseLanguageView.language.name) {
                            tracksNew.append(sub)
                        }
                    }
                }
                
                source.append(VideoIntentModel(sources: sourcesNew, tracks: tracksNew))
            }
        }
    }
    
    private func exitPlayer() {
        let interstitals: [String] = DataCommonModel.shared.extraFind("interstitals") ?? []
        if interstitals.firstIndex(of: "player_will_exit") != nil {
            self.loadView.show()
            AdsInterstitialHandle.shared.tryToPresent(loadView: self.loadView) {
                self.playerView.pause()
                self.dismiss(animated: true)
            }
        } else {
            self.playerView.pause()
            self.dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        // setup controls
        controls.backgroundColor = .clear
        controls.onBack = { [weak self] in
            guard let self = self else { return }
            
            self.exitPlayer()
        }
        controls.onSeason = { [weak self] in
            guard let self = self else { return }
            
            self.chooseSeason()
        }
        
        controls.onSubtitle = {
            let selView = ChooseSubtitleView()
            selView.onOffsub = nil
            selView.onSelectedSub = { subtitle in
                if subtitle.source == .subscene {
                    SubtitleService.shared.downloadSubScene(link: subtitle.file) { webVTT in }
                }
                else {
                    if subtitle.format == .vtt {
                        SubtitleService.shared.downloadSubVTT(link: subtitle.file) { webVTT in }
                    }
                    else {
                        SubtitleService.shared.downloadSubSRT(link: subtitle.file) { webVTT in }
                    }
                }
            }
            selView.show()
        }
        controls.onList = { [weak self] in
            guard let self = self else { return }
            
            self.svView.showIn(view: self.view)
        }
        controls.onLanguage = { [weak self] in
            guard let self = self else { return }
            self.langView.onSelected = { [weak self] lang in
                self?.findOpenSubtitle()
            }
            self.langView.showIn(view: self.view)
        }
        
        // setup player view
        playerView.layer.backgroundColor = UIColor.black.cgColor
        playerView.use(controls: controls)
        playerView.controls?.behaviour.shouldAutohide = true
        playerView.controls?.behaviour.deactivationBlock = { ct in
            ct.behaviour.defaultDeactivationBlock()     // hidden controls
            ct.controlsCoordinator.showBannerIfNeed()   // show banner
        }
        playerView.controls?.behaviour.activationBlock = { ct in
            ct.behaviour.defaultActivationBlock()       // show controls
            ct.controlsCoordinator.hideBannerIfNeed()   // hide banner
        }
        playerView.playbackDelegate = self
        playerView.renderingView.playerLayer.videoGravity = .resizeAspect
        
        switch type {
        case .movie:
            controls.seasonButton?.isHidden = true
        case .tv:
            controls.seasonButton?.isHidden = false
        }
    }
    
    private func updateTitle() {
        switch type {
        case .movie:
            controls.titleLabel?.text = name
        case .tv:
            controls.titleLabel?.text = "[S\(season ?? 0)E\(episode?.episode_number ?? 0)] \(name)"
        }
    }
    
    private func setupProperties() {
        // remove all subtile temp
        SubtitleService.shared.cleanSubDir()
        
        //
        svView.data = source
        svView.onSelected = { [weak self] (pack, tracks) in
            guard let self = self, let url = URL.init(string: pack.file) else { return }
            
            let item = ZemPlayerItem(url: url)
            self.playerView.set(item: item)
            
            SubtitleService.shared.vSubtitles = tracks
        }
        
        //
        langView.onSelected = nil
    }
    
    private func findOpenSubtitle() {
        SubtitleService.shared.findOpenSubtitle(imdbid, season: season, episode: episode?.episode_number ?? 0) { [weak self] in
            self?.findSceneSubtitle()
        }
    }
    
    private func findSceneSubtitle() {
        sceneService = SubsceneHelper(title: name, year: year, season: season ?? 0, episode: episode?.episode_number ?? 0,
                                      type: type.rawValue, language: ChooseLanguageView.language.name)
        
        sceneService?.searching({ files in
            var i: Int = 1
            for file in files {
                SubtitleService.shared.onSubtitles.append(SubtitleModel(file: file, label: "[\(ChooseLanguageView.language.name)][Subscene]-Subtitle\(i)", source: .subscene))
                i += 1
            }
        })
    }
    
    private func chooseSeason() {
        seasonView.delegate = self
        seasonView.idTv = self.tvId ?? 0
        seasonView.seasonSelected = self.season
        seasonView.episodeId = self.episode?.id ?? 0
        seasonView.seasons = self.seasons
        seasonView.episodes = self.episodes
        seasonView.seasonSelected = self.season
        seasonView.show()
    }
    
    @objc func triggerTimer() {
        if self.controls.behaviour.showingControls {
            self.controls.controlsCoordinator.hideBannerIfNeed()
        }
    }
    
    @objc func appMovedToForeground() {
        if needResumeTimer {
            needResumeTimer = false
            setupTimer()
        }
    }
    
    @objc func appMovedToBackground() {
        self.playerView.pause()
        if timer != nil {
            needResumeTimer = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Public
}

extension ZemPlayerController: ZemPlayerPlaybackDelegate {
    public func timeDidChange(player: ZemPlayer, to time: CMTime) {
        var subText: String?
        if let subtitle = SubtitleService.shared.subtitleSelected, let webVTT = subtitle.webVTT {
            subText = webVTT.searchSubtitles(time: Int(CMTimeGetSeconds(time) * 1000))
        }
        playerView.renderingView.subtitleLabel.text = subText
    }
    
    public func startBuffering(player: ZemPlayer) {
        if !controls.behaviour.showingControls {
            controls.behaviour.show()
        }
    }
    
    public func endBuffering(player: ZemPlayer) {
        
    }
    
    public func playbackDidFailed(with error: ZemPlayerPlaybackError) {
        self.alertPlayback { [weak self] in
            guard let self = self else { return }
            
            self.rp(content: cantplay)
        }
    }
    
    fileprivate func rp(content: String) {
        NetworkHelper.shared.rport(name: self.controls.titleLabel?.text ?? "",
                                   type: self.type.rawValue,
                                   year: self.year,
                                   imdb: self.imdbid,
                                   content: content)
    }
}

extension ZemPlayerController: ChooseSeasonDelegate {
    func selectSeason(num: Int, episodes: [TelevisionEpisode]) {
        self.season = num
        self.episodes = episodes
    }
    
    func selectEpisode(num: Int, episode: TelevisionEpisode) {
        guard let episodeCurrent = self.episode?.episode_number else { return }
        
        if episodeCurrent == num {
            self.alertWarning(message: episodeisplay)
        }
        else {
            NetworkHelper.shared.loadT(self.name, season: self.season ?? 0, episode: num, imdb: self.imdbid) { [weak self] data in
                self?.handleData(data, episode: episode)
            }
        }
    }
    
    private func handleData(_ data: [LASDictionary], episode: TelevisionEpisode) {
        if data.count == 0 {
            self.alertNotLink { [weak self] in
                self?.rp(content: emptylink)
            }
        }
        else {
            self.seasonView.closeClicked()
            
            self.timer?.invalidate()
            self.timer = nil
            
            // update: data, episode
            self.data = data
            self.episode = episode
            
            // reload data
            self.prepareData()
            self.setupProperties()
            self.updateTitle()
            self.findOpenSubtitle()
            self.setupTimer()
            
            if let s = source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
                let item = ZemPlayerItem(url: url)
                playerView.set(item: item)
                
                SubtitleService.shared.vSubtitles = s.tracks
            }
        }
    }
}
