import UIKit

class PeopleAPIService: APIService {
    
    func searchPeople(term: String, page: Int, completion: @escaping (Result<PeopleResponse, PMError>) -> ()) {
        guard let url = makeURL("search/person") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["query": term, "page": page], completion: completion)
    }
    
    func fetchPeoplePopular(page: Int, completion: @escaping (Result<PeopleResponse, PMError>) -> ()) {
        guard let url = makeURL("person/popular") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchDetail(id: Int, completion: @escaping (Result<People, PMError>) -> ()) {
        guard let url = makeURL("person/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func fetchMovieCredits(id: Int, completion: @escaping (Result<PeopleMovieResponse, PMError>) -> ()) {
        guard let url = makeURL("person/\(id)/movie_credits") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func fetchTVCredits(id: Int, completion: @escaping (Result<PeopleTelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("person/\(id)/tv_credits") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
}
