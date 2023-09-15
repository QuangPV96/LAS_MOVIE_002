import UIKit

class MovieNowPlayingVM: BaseViewModel {
    private (set) var data : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    private (set) var page: Int = 1
    private (set) var isNextPage: Bool = true
    
    override init() {
        super.init()
        self.page = 1
        self.isNextPage = true
        self.apiService = MovieAPIService()
    }
    
    func loadPage(data: [Movie], page: Int){
        self.page = page
        self.data = data
        self.isNextPage = true
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        if !isNextPage {
            self.bindViewModelToController()
            return
        }
        
        isLoading = true
        
        (self.apiService as! MovieAPIService).fetchNowPlaying(page: self.page) { result in
            switch result {
            case .success(let tmp):
                self.data = tmp.results
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
    
    func getSizeData() -> Int{
        return data.count
    }
    
}
