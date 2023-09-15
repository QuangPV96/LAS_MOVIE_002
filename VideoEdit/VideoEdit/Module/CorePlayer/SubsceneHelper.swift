//
//  SubsceneHelper.swift
//  LASCore
//
//  Created by Quynh Nguyen on 19/07/2022.
//

import UIKit
import SwiftSoup

private var _host = "https://subscene.com"
private let _seasons: [String: Int] = [
    "FIRST": 1,
    "SECOND": 2,
    "THIRD": 3,
    "FOURTH": 4,
    "FIFTH": 5,
    "SIXTH": 6,
    "SEVENTH": 7,
    "EIGHTH": 8,
    "NINTH": 9,
    "TENTH": 10,
    "ELEVENTH": 11,
    "TWELFTH": 12,
    "THIRTEENTH": 13,
    "FOURTEENTH": 14,
    "FIFTEENTH": 15,
    "SIXTEENTH": 16,
    "SEVENTEENTH": 17,
    "EIGHTEENTH": 18,
    "NINETEENTH": 19,
    "TWENTIETH": 20,
    "TWENTYFIRST": 21,
    "TWENTYSECOND": 22,
    "TWENTYTHIRD": 23,
    "TWENTYFOURTH": 24,
    "TWENTYFIFTH": 25,
    "TWENTYSIXTH": 26,
    "TWENTYSEVENTH": 27,
    "TWENTYEIGHTTH": 28,
    "TWENTYNINETH": 29,
    "THIRTIETH": 30
]

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

public class SubsceneHelper: NSObject {
    let title: String
    let year: Int
    let season: Int
    let episode: Int
    let type: String    // movie or tv
    let language: String
    
    public init(title: String, year: Int, season: Int, episode: Int, type: String, language: String) {
        self.title = title
        self.year = year
        self.season = season
        self.episode = episode
        self.type = type
        self.language = language
    }
    
    private func term() -> String {
        var term = ""
        switch type {
        case "movie":
            term = "\(title) (\(year))"
        case "tv":
            if let key = _seasons.someKey(forValue: season) {
                term = "\(title) - \(key) Season"
            }
        default: break
        }
        return term
    }
    
    public func searching(_ completion: @escaping (_ files: [String]) -> Void) {
        let titleEncode = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let parameters = "query=\(titleEncode)&l="
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://subscene.com/subtitles/searchbytitle")!,timeoutInterval: Double.infinity)
        request.addValue("https://subscene.com", forHTTPHeaderField: "Origin")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9", forHTTPHeaderField: "Accept")
        request.addValue("https://subscene.com/subtitles/searchbytitle", forHTTPHeaderField: "Referer")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
            guard let html = String(data: data, encoding: .utf8) else {
                completion([])
                return
            }
            let files = self.parseHTML(html, self.term())
            completion(files)
        }
        
        task.resume()
    }
    
    private func parseHTML(_ html: String, _ term: String) -> [String] {
        // find link detail
        var detailLinks: [String] = []
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let titlesDIV = try doc.select("div.title")
            
            for tit in titlesDIV {
                do {
                    let aText = try tit.text()
                    let href = try tit.select("a").attr("href")
                    
                    if term.lowercased() == aText.lowercased() {
                        let link = "\(_host)\(href)"
                        if !detailLinks.contains(link) {
                            detailLinks.append(link)
                        }
                    }
                } catch { }
            }
        } catch { }
        
        // find link file
        var links: [String] = []
        for link in detailLinks {
            if let content = self.fetchContent(link) {
                do {
                    let doc: Document = try SwiftSoup.parse(content)
                    let rows = try doc.select("span:contains(\(self.language)")
                    for ele in rows {
                        guard let parent = ele.parent() else {
                            continue
                        }
                        
                        switch self.type {
                        case "movie":
                            if let href = try? parent.attr("href") {
                                let link = "\(_host)\(href)"
                                if !links.contains(link) {
                                    links.append(link)
                                }
                            }
                        case "tv":
                            if let text = try? parent.text(),
                               let matches = text.matchingStrings(regex: "s([0-9]+)e([0-9]+)").first, matches.count == 3 {
                                
                                if Int(matches[1]) ?? 0 == self.season && Int(matches[2]) ?? 0 == self.episode {
                                    if let href = try? parent.attr("href") {
                                        let link = "\(_host)\(href)"
                                        if !links.contains(link) {
                                            links.append(link)
                                        }
                                    }
                                }
                            }
                        default: break
                        }
                    }
                } catch { }
            }
        }
        
        //
        var files: [String] = []
        for link in links {
            if let content = self.fetchContent(link) {
                do {
                    let doc: Document = try SwiftSoup.parse(content)
                    if let aTag = try doc.select("a[id=downloadButton]").first(),
                       let href = try? aTag.attr("href") {
                        let link = "\(_host)\(href)"
                        if !files.contains(link) {
                            files.append(link)
                        }
                    }
                } catch { }
            }
        }
        return files
    }
    
    private func fetchContent(_ link: String) -> String? {
        guard let url = URL(string: link) else { return nil }
        guard let html = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return html
    }
}
