import Foundation

struct DataCommonModel {
    private let key = "fizfiozpen"
    
    fileprivate var fiozpen: Date {
        if UserDefaults.standard.object(forKey: key) as? Date == nil {
            UserDefaults.standard.set(Date(), forKey: key)
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.object(forKey: key) as! Date
    }
    
    fileprivate var time: Date?
    fileprivate var extra: String? {
        didSet {
            if let json = extra?.toJson {
                extraJSON = json
            } else {
                extraJSON = nil
            }
        }
    }
    fileprivate var extraJSON: MoDictionary?
    
    fileprivate var _allAds: [AdsObject] = adsesDefault
    fileprivate var adsActtive: [AdsObject] {
        return _allAds.sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public var openRatingView: Bool {
        guard let _time = time else { return false }
        return _time.timeIntervalSince1970 >= fiozpen.timeIntervalSince1970
    }
    
    public var isRating: Bool = false
    
    // MARK: - static instance
    public static var shared = DataCommonModel()
    
    init() {
        let _ = fiozpen
    }
    
    // MARK: - keys admob
    @LocalStorage(key: "admob_banner", value: "ca-app-pub-2299291161271404/8272939431")
    public var admob_banner: String
    
    @LocalStorage(key: "admob_inter", value: "ca-app-pub-2299291161271404/2214512133")
    public var admob_inter: String
    
    @LocalStorage(key: "admob_inter_splash", value: "ca-app-pub-2299291161271404/9398318841")
    public var admob_inter_splash: String
    
    @LocalStorage(key: "admob_reward", value: "ca-app-pub-2299291161271404/5192029261")
    public var admob_reward: String
    
    @LocalStorage(key: "admob_reward_interstitial", value: "ca-app-pub-2299291161271404/6959857763")
    public var admob_reward_interstitial: String
    
    @LocalStorage(key: "admob_small_native", value: "ca-app-pub-2299291161271404/9060203653")
    public var admob_small_native: String
    
    @LocalStorage(key: "admob_medium_native", value: "ca-app-pub-2299291161271404/5646776094")
    public var admob_medium_native: String
    
    @LocalStorage(key: "admob_manual_native", value: "ca-app-pub-2299291161271404/5781387903")
    public var admob_manual_native: String
    
    @LocalStorage(key: "admob_appopen", value: "ca-app-pub-2299291161271404/1975920555")
    public var admob_appopen: String
    
    
    // MARK: - keys applovin
    @LocalStorage(key: "applovin_banner", value: "cfdbab700207037d")
    public var applovin_banner: String
    
    @LocalStorage(key: "applovin_inter", value: "f1e02fbbb4a8f5e1")
    public var applovin_inter: String
    
    @LocalStorage(key: "applovin_inter_splash", value: "398eb768f34ae103")
    public var applovin_inter_splash: String
    
    @LocalStorage(key: "applovin_reward", value: "1a327f075529f885")
    public var applovin_reward: String
    
    @LocalStorage(key: "applovin_small_native", value: "12bab982eaa84646")
    public var applovin_small_native: String
    
    @LocalStorage(key: "applovin_medium_native", value: "9be43f9dca78a291")
    public var applovin_medium_native: String
    
    @LocalStorage(key: "applovin_manual_native", value: "1dd70b411dd4798f")
    public var applovin_manual_native: String
    
    @LocalStorage(key: "applovin_appopen", value: "35fa72c23c26a56e")
    public var applovin_appopen: String
    
    // ?
    @LocalStorage(key: "applovin_id", value: "")
    public var applovin_id: String
}

extension DataCommonModel {
    public func extraFind<T>(_ key: String) -> T? {
        return (extraJSON ?? [:])[key] as? T
    }
    
    public func adsAvailableFor(_ name: AdsName) -> AdsObject? {
        return self.adsActtive.filter({ $0.name == .admob }).first
    }
    
    public func adsAvailableFor(_ unit: AdsUnit) -> [AdsObject] {
        return self.adsActtive.filter({ $0.adUnits.contains(unit.rawValue) }).sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public func isAvailable(_ name: AdsName, _ unit: AdsUnit) -> Bool {
        return self.adsAvailableFor(unit).contains(where: { $0.name == name })
    }
    
    public mutating func readData() {
        let data = NetworksService.shared.dataCommonSaved()
        
        if let timestamp = data["time"] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: timestamp)
        }
        if let listAds = data["adses"] as? [MoDictionary] {
            self._allAds.removeAll()
            for dic in listAds {
                if let name = dic["name"] as? String, let type = AdsName(rawValue: name) {
                    let m = AdsObject(name: type, sort: dic["sort"] as? Int, adUnits: (dic["adUnits"] as? [String]) ?? [])
                    self._allAds.append(m)
                }
            }
        }
        
        self.isRating = (data["isRating"] as? Bool) ?? false
        self.extra = data["extra"] as? String
    }
    
}
