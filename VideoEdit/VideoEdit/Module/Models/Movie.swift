import Foundation
import UIKit

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Identifiable {
    
    let id: Int
    let imdb_id: String?
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let vote_count: Int
    let runtime: Int?
    let release_date: String?
    let genre_ids: [Int]?
    let original_language: String?
    
    let character: String?
    
    let genres: [Genre]?
    let credits: MovieCreditResponse?
    let videos: MovieVideoResponse?
    let images: MovieImageResponse?
    
    var dictionary: NSDictionary  {
        return ["id": id,
                "imdb_id": imdb_id as Any,
                "title": title,
                "backdrop_path": backdrop_path as Any,
                "poster_path": poster_path as Any,
                "overview": overview,
                "vote_average": vote_average,
                "vote_count": vote_count,
                "runtime": runtime as Any,
                "release_date": release_date as Any,
                "genre_ids": genre_ids as Any,
                "genres": genreList,
                "character": character as Any,
                "credits": credits?.dictionary as Any,
                "videos": videos?.dictionary as Any,
                "images": images?.dictionary  as Any
                ]
    }
    
    var imdb: String {
        return imdb_id ?? ""
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(backdrop_path)
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
    var imdbStr: String {
        return String(format: "%.1f/10", vote_average)
    }
    
    var voteAverageStr: String {
        return String(format: "%.1f", vote_average)
    }

    var ratingStr: String {
        return String(format: "%.1f/10 IMDb", vote_average)
    }
    
    
    var yearInt: Int {
        guard let releaseDate = self.release_date, let date = UtilService.dateFormatter.date(from: releaseDate) else {
            return 0
        }
        return Int(UtilService.yearFormatter.string(from: date)) ?? 0
    }
    
    var releaseTimestamp: TimeInterval {
        guard let releaseDate = self.release_date else {
            return 0
        }
        
        if let date = UtilService.dateFormatter.date(from: releaseDate) {
            return date.timeIntervalSince1970
        }
        return 0
    }

    var cast: [MovieCast]? {
        credits?.cast
    }
    
    var crew: [MovieCrew]? {
        credits?.crew
    }
    
    var genreList: [NSDictionary] {
        var listGenres = [NSDictionary]()
        
        guard let genres = genres else {
            return []
        }
        for genre in genres {
            listGenres.append(genre.dictionary)
        }
        return listGenres
    }
    
    var genreText: String {
        if let _genres = genres {
            return _genres.map({ $0.name }).joined(separator: ", ")
        }
        else {
            if let _ids = genre_ids {
                return MovieGenreVM.shared.data.filter({ _ids.contains($0.id) }).map({ $0.name }).joined(separator: ", ")
            }
        }
        return not_available
    }
    
    var durationText: String {
        guard  let runtime = self.runtime, runtime > 0 else {
            return not_available
        }
        return TimeInterval(runtime).stringFromTimeInterval()
    }
    
    var ratingText: String {
        return String(format: "%.1f", vote_average)
    }
    
    var voteAverageText: String {
        return String(format: "%.1f", vote_average)
    }
    
    var releaseText: String {
        guard let releaseDate = self.release_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: releaseDate) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd. yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }

}

struct Video: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "key": key,
                "name": name,
                "site": site
                ]
    }
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/embed/\(key)")
    }
    
    var youtubeThumbnailURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://i.ytimg.com/vi/\(key)/hqdefault.jpg")
    }
}

struct Cast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "character": character,
                "name": name,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any
                ]
    }
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
    
}

struct MovieCreditResponse: Decodable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
    
    var dictionary : NSDictionary {
        return [
                "cast":movieCastList,
                "crew":movieCrewList
                ]
    }
    
    var movieCastList: [NSDictionary] {
        var listCast = [NSDictionary]()
        
        for castObject in cast {
            listCast.append(castObject.dictionary)
        }
        return listCast
    }
    
    var movieCrewList: [NSDictionary] {
        var listCrew = [NSDictionary]()
        
        for crewObject in crew {
            listCrew.append(crewObject.dictionary)
        }
        return listCrew
    }
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "character": character,
                "name": name,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any
                ]
    }
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
    
}
struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "job": job,
                "name": name,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any
                ]
    }
    
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
}

struct MovieVideoResponse: Decodable {
    let results: [Video]
    
    var dictionary : NSDictionary {
        return [
            "results":movieVideoList
        ]
    }
    
    var movieVideoList: [NSDictionary] {
        var listVideo = [NSDictionary]()
        
        for video in results {
            listVideo.append(video.dictionary)
        }
        return listVideo
    }
    
}

struct MovieImageResponse: Decodable {
    let backdrops: [MovieImageItem]
    let logos: [MovieImageItem]
    let posters: [MovieImageItem]
    
    var dictionary : NSDictionary {
        return [
            "backdrops":movieImageList(data: backdrops),
            "logos":movieImageList(data: logos),
            "posters":movieImageList(data: posters)
        ]
    }
    
    func  movieImageList(data:[MovieImageItem]) -> [NSDictionary] {
        var listImage = [NSDictionary]()
        
        for image in data {
            listImage.append(image.dictionary)
        }
        return listImage
    }
}

struct MovieImageItem: Decodable {
    let aspect_ratio: Double
    let height: Int?
    let width: Int?
    let iso_639_1: String?
    let file_path: String?
    let vote_average: Double?
    let vote_count: Int?
    
    var dictionary: NSDictionary {
        return [
                "aspect_ratio": aspect_ratio,
                "height": height as Any,
                "width": width as Any,
                "iso_639_1": iso_639_1 as Any,
                "file_path": file_path as Any,
                "vote_average": vote_average as Any,
                "vote_count": vote_count as Any
                ]
    }
    
    var filePathURL: URL? {
        return UtilService.makeURLImage(file_path)
    }
}
