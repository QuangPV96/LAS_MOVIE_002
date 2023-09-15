import Foundation

struct TelevisionResponse: Decodable {
    let results: [Television]
}

struct Television: Decodable, Identifiable {
    //
    let id: Int
    let name: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let vote_count: Int
    let first_air_date: String?
    let genre_ids: [Int]?
    
    let character: String?
    
    //
    let genres: [Genre]?
    let credits: TelevisionCreditResponse?
    let videos: TelevisionVideoResponse?
    let images: TelevisionImageResponse?
    let networks: [TelevisionNetwork]?
    let seasons: [TelevisionSeason]?
    
    var dictionary: NSDictionary  {
        return ["id": id,
                "name": name,
                "backdrop_path": backdrop_path as Any,
                "poster_path": poster_path  as Any,
                "overview": overview,
                "vote_average": vote_average,
                "vote_count": vote_count,
                "first_air_date": first_air_date  as Any,
                "genre_ids": genre_ids  as Any,
                "character": character  as Any,
                
                "genres": genreList  as Any,
                "credits": credits?.dictionary  as Any,
                "videos": videos?.dictionary as Any,
                "images": images?.dictionary  as Any,
                "networks": tvNetworkList  as Any,
                "seasons": seasonList
                ]
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(backdrop_path)
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
    var imdbText: String {
        return String(format: "%.1f/10", vote_average)
    }
    
    var voteAverageText: String {
        return String(format: "%.1f", vote_average)
    }
    
    var ratingText: String {
        return String(format: "%.1f", vote_average)
    }
    
    var firstYearText: String {
        guard let first_air_date = self.first_air_date else {
            return not_available
        }
        guard let date = UtilService.dateFormatter.date(from: first_air_date) else {
            return not_available
        }
        return UtilService.yearFormatter.string(from: date)
    }
    
    var firstAirTimestamp: TimeInterval {
        guard let first_air_date = self.first_air_date else {
            return 0
        }
        
        if let date = UtilService.dateFormatter.date(from: first_air_date) {
            return date.timeIntervalSince1970
        }
        return 0
    }
    
    var genreText: String {
        if let _genres = genres {
            return _genres.map({ $0.name }).joined(separator: ", ")
        }
        else {
            if let _ids = genre_ids {
                return TelevisionGenreVM.shared.data.filter({ _ids.contains($0.id) }).map({ $0.name }).joined(separator: ", ")
            }
        }
        return not_available
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
    
    var tvNetworkList: [NSDictionary] {
        var listNetwork = [NSDictionary]()
        
        guard let networks = networks else {
            return []
        }

        for network in networks {
            listNetwork.append(network.dictionary)
        }
        return listNetwork
    }
    
    var seasonList: [NSDictionary] {
        var listSeason = [NSDictionary]()
        
        guard let seasons = seasons else {
            return []
        }

        for season in seasons {
            listSeason.append(season.dictionary)
        }
        return listSeason
    }
    
    var cast: [Cast]? {
        credits?.cast
    }
    
    var crew: [TelevisionCrew]? {
        credits?.crew
    }

}

struct TelevisionCreditResponse: Decodable {
    let cast: [Cast]
    let crew: [TelevisionCrew]
    
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

struct TelevisionCrew: Decodable, Identifiable {
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

struct TelevisionVideoResponse: Decodable {
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

struct TelevisionImageResponse: Decodable {
    let backdrops: [TelevisionImageItem]
    let logos: [TelevisionImageItem]
    let posters: [TelevisionImageItem]
    
    var dictionary : NSDictionary {
        return [
            "backdrops":televisionImageList(data: backdrops),
            "logos":televisionImageList(data: logos),
            "posters":televisionImageList(data: posters)
        ]
    }
    
    func  televisionImageList(data:[TelevisionImageItem]) -> [NSDictionary] {
        var listImage = [NSDictionary]()
        for image in data {
            listImage.append(image.dictionary)
        }
        return listImage
    }
}

struct TelevisionNetwork: Decodable, Identifiable {
    let id: Int
    let name: String?
    let logo_path: String?
    let origin_country: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "name": name as Any,
                "logo_path": logo_path as Any,
                "origin_country": origin_country as Any
                ]
    }
    
    var logoURL: URL? {
        return UtilService.makeURLImage(logo_path)
    }
}

struct TelevisionSeason: Decodable, Identifiable {
    let id: Int
    let air_date: String?
    let episode_count: Int?
    let name: String?
    let overview: String?
    let poster_path: String?
    let season_number: Int?
    let episodes: [TelevisionEpisode]?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "air_date": air_date as Any,
                "episode_count": episode_count as Any,
                "name": name as Any,
                "overview": overview as Any,
                "poster_path": poster_path as Any,
                "season_number": season_number as Any,
                "episodes": episodeList
                ]
    }
    
    var airDateText: String {
        guard let air_date = self.air_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: air_date) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
    var episodeList: [NSDictionary] {
        var listEpisode = [NSDictionary]()
        guard let episodes = episodes else {
            return []
        }

        for episode in episodes {
            listEpisode.append(episode.dictionary)
        }
        return listEpisode
    }
}

struct TelevisionEpisode: Decodable, Identifiable {
    let id: Int
    let name: String?
    let overview: String?
    let air_date: String?
    let still_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let episode_number: Int?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "name": name as Any,
                "overview": overview as Any,
                "air_date": air_date as Any,
                "still_path": still_path as Any,
                "vote_average": vote_average as Any,
                "vote_count": vote_count as Any,
                "episode_number": episode_number as Any
                ]
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(still_path)
    }
    
    var airDateText: String {
        guard let air_date = self.air_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: air_date) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd. yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
}

struct TvShowCast: Decodable, Identifiable {
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

struct TelevisionImageItem: Decodable {
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

struct TelevisionExternalIds: Decodable, Identifiable {
    var id: Int
    var imdb_id: String?
}
