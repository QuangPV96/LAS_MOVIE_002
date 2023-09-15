import UIKit

class BaseViewModel: NSObject {
    var error : PMError?  {
        didSet {
            self.bindViewModelToController()
        }
    }
    var apiService: APIService!
    var isLoading: Bool = false
    var bindViewModelToController : (() -> ()) = {}
}
