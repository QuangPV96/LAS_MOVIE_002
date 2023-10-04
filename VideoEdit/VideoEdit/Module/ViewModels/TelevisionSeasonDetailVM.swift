import UIKit

class TelevisionSeasonDetailVM: BaseViewModel {
    private (set) var data : TelevisionSeason? {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var tvId: Int!
    private (set) var seasonNumber: Int!
    
    init(tvId: Int, seasonNumber: Int) {
        super.init()
        self.tvId = tvId
        self.seasonNumber = seasonNumber
        self.apiService = TVShowAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVShowAPIService).fetchSeasonDetail(tvId: self.tvId, seasonNumber: self.seasonNumber) { result in
            switch result {
            case .success(let tmp):
                self.data = tmp
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

