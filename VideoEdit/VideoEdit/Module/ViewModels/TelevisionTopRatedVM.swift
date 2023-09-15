import UIKit

class TelevisionTopRatedVM: BaseViewModel {
    private (set) var data : [Television] = [] {
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
        self.apiService = TVShowAPIService()
    }
    
    func loadPage(data: [Television], page: Int){
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
        (self.apiService as! TVShowAPIService).fetchTopRated(page: self.page) { result in
            switch result {
            case .success(let response):
                self.data += response.results
                self.isNextPage = response.results.count > 0
                self.page = self.isNextPage ? self.page + 1 : self.page
            case .failure(let error):
                self.error = error
                self.isNextPage = false
            }
            self.isLoading = false
        }
    }
    
    func getSizeData() -> Int{
        return data.count
    }
    
}

