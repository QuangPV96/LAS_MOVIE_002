import UIKit

class APIService: NSObject {
    
    fileprivate var apikey_themoviedb: String {
        
        if DataCommonModel.shared.extraFind("key_movie_db") == nil {
            return AppSetting.key_movie_db
        } else {
            let key: String = DataCommonModel.shared.extraFind("key_movie_db")!
            return key
        }
    }
    
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    func makeURL(_ path: String) -> URL? {
        let link = "\(prefix_host_themoviedb)\(path)?api_key=\(apikey_themoviedb)&language=en-US&page=1"
        return URL(string: link)
    }
    
    func loadURLAndDecoder<D: Decodable>(url: URL,
                                         params: [String: Any]? = nil,
                                         completion: @escaping(Result<D,PMError>) -> Void) {
        
        //
        guard let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        //
        var queryItems = [URLQueryItem(name: "api_key", value: apikey_themoviedb)]
        if let params = params {
            queryItems.append(contentsOf: params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            })
        }
        urlComponents.queryItems = queryItems
        
        //
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        //
        URLSession.shared.dataTask(with: finalURL){[weak self] (data, response, error) in
            guard let _self = self else {
                completion(.failure(.none))
                return
            }
            
            if error != nil {
                _self.excuteCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                _self.excuteCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            guard let data = data else {
                _self.excuteCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            do {
                let decodeResponse = try _self.jsonDecoder.decode(D.self, from: data)
                _self.excuteCompletionHandlerInMainThread(with: .success(decodeResponse), completion: completion)
            } catch let tmp {
                print("Error parse object")
                print(tmp)
                _self.excuteCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
        }.resume()
    }
    
    private func excuteCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, PMError>,
                                                                   completion: @escaping(Result<D, PMError>) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }
}
