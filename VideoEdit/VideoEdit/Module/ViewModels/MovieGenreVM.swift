import UIKit

class MovieGenreVM: BaseViewModel {
    private (set) var data : [Genre] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    static let shared = MovieGenreVM()
    
    override init() {
        super.init()
        self.apiService = MovieAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! MovieAPIService).fetchGenre { result in
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
