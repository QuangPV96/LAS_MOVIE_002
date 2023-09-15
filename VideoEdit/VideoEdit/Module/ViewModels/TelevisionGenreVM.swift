import UIKit

class TelevisionGenreVM: BaseViewModel {
    private (set) var data : [Genre] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    static let shared = TelevisionGenreVM()
    
    override init() {
        super.init()
        self.apiService = TVShowAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! TVShowAPIService).fetchGenre { result in
            switch result {
            case .success(let genre):
                self.data = genre.genres
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

