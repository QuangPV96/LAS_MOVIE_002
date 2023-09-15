import UIKit

class MovieAPIService: APIService {
    // MARK: - genre
    func fetchGenre(_ completion: @escaping (Result<GenreResponse, PMError>) -> ()) {
        guard let url = makeURL("genre/movie/list") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    // MARK: - popular / top rated / up coming....
    func fetchNowPlaying(page: Int, _ completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("movie/now_playing") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchPopular(page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("movie/popular") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchTopRated(page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("movie/top_rated") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchUpcoming(page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("movie/upcoming") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchDiscoverByGenre(genreId: Int, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("discover/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page, "with_genres": genreId], completion: completion)
    }
    
    func search(term: String, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": term,
            "page": page
        ], completion: completion)
    }
    
    // MARK: - detail
    func fetchDetail(id: Int, completion: @escaping (Result<Movie, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["append_to_response":"videos,images,credits"], completion: completion)
    }
    
    // MARK: - detail more
    func fetchRecommendation(id: Int, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSimilar(id: Int, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
}
