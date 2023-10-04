import UIKit

class PeopleCreditVM: BaseViewModel {
    // using for known for
    var data : [Any] {
        return movies + televisions
    }
    
    // using for acting history
    var actings: [ActingHistory] = []
    
    //
    private (set) var movies : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var televisions : [Television] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = PeopleAPIService()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! PeopleAPIService).fetchMovieCredits(id: self.id) { result in
            switch result {
            case .success(let tmp):
                self.movies = tmp.cast
            case .failure(let error):
                self.error = error
            }
            self.loadTVsData()
            self.handleSourceActing()
        }
    }
    
    private func loadTVsData() {
        (self.apiService as! PeopleAPIService).fetchTVCredits(id: self.id) { result in
            switch result {
            case .success(let tmp):
                self.televisions = tmp.cast
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
            self.handleSourceActing()
        }
    }
    
    private func handleSourceActing() {
        self.actings.removeAll()
        
        var result: [ActingHistory] = []
        movies.forEach { item in
            if !(item.title.isEmpty && (item.character ?? "").isEmpty && item.releaseTimestamp == 0) {
                result.append(ActingHistory(title: item.title, character: item.character ?? "", releaseTimestamp: item.releaseTimestamp))
            }
        }
        televisions.forEach { item in
            if !(item.name.isEmpty && (item.character ?? "").isEmpty && item.firstAirTimestamp == 0) {
                result.append(ActingHistory(title: item.name, character: item.character ?? "", releaseTimestamp: item.firstAirTimestamp))
            }
        }
        // sort
        self.actings = result.sorted(by: { (a, b) -> Bool in
            return a.releaseTimestamp > b.releaseTimestamp
        })
        self.bindViewModelToController()
    }
}
