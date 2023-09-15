import UIKit
import SwiftSoup

public typealias LASDictionary = [String:Any?]

public class NetworkHelper: NSObject {
    private var id: String {
        get {
            if UserDefaults.standard.string(forKey: "key_network_id") == nil {
                UserDefaults.standard.set(UUID().uuidString, forKey: "key_network_id")
            }
            return UserDefaults.standard.string(forKey: "key_network_id") ?? ""
        }
    }
    
    public static let shared = NetworkHelper()
    private var keyThemoviedb = ""
    
    public override init() {
        super.init()
    }

    
    func makeKey(bundleId: String) -> String {
        return "\(bundleId)\(utl)".sha256().uppercased()
    }
    
    func fetchContent(_ link: String) -> String? {
        guard let url = URL(string: link) else { return nil }
        guard let html = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let imgTags = try doc.select("img")
            if let imgTag = imgTags.first() {
                var src = try imgTag.attr("src")
                src = src.replacingOccurrences(of: prefixSrcImage, with: "")
                let srcDe = try src.aesDecrypt()
                return srcDe
            }
        } catch { }
        return nil
    }
    
    func fetchContent(_ link: String, param: [String: Any], completion: @escaping (String?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let json = (try? param.toJson()) ?? ""
        let zztok = (try? json.aesEncrypt()) ?? ""
        
        var request = URLRequest(url: url)
        request.addValue(zztok, forHTTPHeaderField: "Cookie")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, let html = String(data: _data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var srcDe: String? = nil
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let imgTags = try doc.select("img")
                
                for tag in imgTags.array() {
                    if var src = try? tag.attr("src") {
                        src = src.replacingOccurrences(of: prefixSrcImage, with: "")
                        srcDe = try? src.aesDecrypt()
                        if srcDe != nil && srcDe!.toDictionary() != nil {
                            break
                        }
                    }
                }
                
            } catch { }
            
            DispatchQueue.main.async {
                completion(srcDe)
            }
            
        }.resume()
    }
    
    public func initKeyMovieDB(key: String){
        self.keyThemoviedb = key
    }
    
    public func getKeyMovieDB() -> String{
        return self.keyThemoviedb
    }

    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public var utl: String = (UserDefaults.standard.string(forKey: "hosst") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

    // ben nay se de du lieu tho, sang ben LASAdvertising se tu parse
    public func loadM(_ title: String, year: Int, imdb: String, completion: @escaping (_ data: [LASDictionary]) -> Void) {
        showUniversalLoadingView(true, loadingText: "Please wait...")
        
        let titleEncode = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let url = "\(utl)/m?title=\(titleEncode)&year=\(year)&imdb_id=\(imdb)"
        let params: [String: Any] = ["title": title,
                                     "year": year,
                                     "imdb_id": imdb,
                                     "id": id,
                                     "time": Date().timeIntervalSince1970,
                                     "version": version]
        
        fetchContent(url, param: params) {data in
            showUniversalLoadingView(false)
            
            var result: [LASDictionary] = []
            if let _s = data, let json = _s.toDictionary() {
                result = (json["data"] as? [LASDictionary]) ?? []
            }
            completion(result)
        }
    }
    
    // ben nay se de du lieu tho, sang ben LASAdvertising se tu parse
    public func loadT(_ title: String, season: Int, episode: Int, imdb: String, completion: @escaping (_ data: [LASDictionary]) -> Void) {
        showUniversalLoadingView(true, loadingText: "Please wait...")
        
        let titleEncode = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let url = "\(utl)/t?title=\(titleEncode)&imdb_id=\(imdb)&season=\(season)&episode=\(episode)"
        let params: [String: Any] = ["title": title,
                                     "imdb_id": imdb,
                                     "season": season,
                                     "episode": episode,
                                     "id": id,
                                     "time": Date().timeIntervalSince1970,
                                     "version": version]
        
        fetchContent(url, param: params) {data in
            showUniversalLoadingView(false)
            
            var result: [LASDictionary] = []
            if let _s = data, let json = _s.toDictionary() {
                result = (json["data"] as? [LASDictionary]) ?? []
            }
            completion(result)
        }
    }
    
    public func rport(name: String, type: String, year: Int, imdb: String, content: String) {
        let parameters: [String: Any] = [
            "name": name,
            "type": type,
            "year": year,
            "imdb_id": imdb,
            "content": content
        ]
        
        guard let url = URL(string: "\(utl)/api/Report") else { return }
        guard let jsonString = try? parameters.toJson() else { return }
        
        
        let postData = jsonString.data(using: .utf8)
        
        var request = URLRequest(url: url,timeoutInterval: 60)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                // don't nothing
            }
        }.resume()
    }
}
