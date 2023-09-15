import UIKit

class MovieDetailVM: BaseViewModel {
    private (set) var data : Movie? {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = MovieAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! MovieAPIService).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let movie):
                self.data = movie
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}
