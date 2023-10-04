import UIKit
import GoogleMobileAds

public class AdmobHandle: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        guard let _ = DataCommonModel.shared.adsAvailableFor(.admob) else {
            return false
        }
        
        return _isReady
    }
    
    @objc public var idsTest: [String] = []
    
    // MARK: - initial
    @objc public static let shared = AdmobHandle()
    
    // MARK: private
    
    // MARK: public
    @objc public func awake(completion: @escaping () -> Void) {
        var ids: [String] = idsTest
        ids.append(GADSimulatorID)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ids
        
        GADMobileAds.sharedInstance().start { _ in
            self._isReady = true
            completion()
        }
    }
}
