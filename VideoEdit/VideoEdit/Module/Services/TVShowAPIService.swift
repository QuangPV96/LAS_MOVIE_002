import UIKit

class TVShowAPIService: APIService {
    // MARK: - genre
    func fetchGenre(_ completion: @escaping (Result<GenreResponse, PMError>) -> ()) {
        guard let url = makeURL("genre/tv/list") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    // MARK: - latest / top rated / up coming....
    func fetchLatest(_ completion: @escaping (Result<Television, PMError>) -> ()) {
        guard let url = makeURL("tv/latest") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func fetchPopular(page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("tv/popular") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchTopRated(page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("tv/top_rated") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchTvAiringToday(page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("tv/airing_today") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchTvOnTheAir(page: Int, completion: @escaping (Result<TelevisionResponse,PMError>) -> ()){
        guard let url = makeURL("tv/on_the_air") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchTvAirToDay(page: Int, completion: @escaping (Result<TelevisionResponse,PMError>) -> ()){
        guard let url = makeURL("tv/airing_today") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchDiscoverByGenre(genreId: Int, page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("discover/tv") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page, "with_genres": genreId], completion: completion)
    }
    
    func search(_ term: String, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("search/tv") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": term
        ], completion: completion)
    }
    
    // MARK: - detail
    func fetchDetail(id: Int, completion: @escaping (Result<Television, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["append_to_response":"videos,images,credits"], completion: completion)
    }
    
    // MARK: - detail more
    func fetchRecommendation(id: Int, page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSimilar(id: Int, page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSeasonDetail(tvId: Int, seasonNumber: Int, completion: @escaping (Result<TelevisionSeason, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(tvId)/season/\(seasonNumber)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func searchIMDB(id: Int, completion: @escaping (Result<TelevisionExternalIds, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/external_ids") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
}
