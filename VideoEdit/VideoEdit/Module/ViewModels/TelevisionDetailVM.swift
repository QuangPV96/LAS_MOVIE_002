import UIKit

class TelevisionDetailVM: BaseViewModel {
    private (set) var data : Television? {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = TVShowAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVShowAPIService).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let television):
                self.data = television
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

