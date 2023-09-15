import Foundation

struct PeopleResponse: Decodable {
    let results: [People]
}

struct People: Decodable, Identifiable {
    let id: Int
    let name: String
    let popularity: Double
    let known_for_department: String?
    let profile_path: String?
    let biography: String?
    
    let known_for: [PeopleKnowFor]?
    
    let birthday: String?
    let also_known_as: [String]?
    let gender: Int?
    let place_of_birth: String?
    
    var dictionary: NSDictionary {
        return ["id": id,
                "name": name ,
                "popularity": popularity,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any,
                "biography": biography as Any,
                "known_for": knowForList,
                "birthday": birthday as Any,
                "also_known_as": also_known_as as Any,
                "gender": gender as Any,
                "place_of_birth": place_of_birth as Any
                ]
        
    }
    
    var knowForList: [NSDictionary] {
        var listKnowFor = [NSDictionary]()
        
        guard let known_for = known_for else {
            return []
        }
        for knownforObject in known_for {
            listKnowFor.append(knownforObject.dictionary)
        }
        return listKnowFor

    }
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
    
    var knowForDepartmentText: String {
        return known_for_department ?? not_available
    }
    
    var birthdayText: String {
        guard let birthday = self.birthday else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: birthday) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd. yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
    
    var placeOfBirthText: String {
        return place_of_birth ?? not_available
    }
}

struct PeopleKnowFor: Decodable, Identifiable {
    let id: Int
    let title: String?
    let media_type: String?
    let genre_ids: [Int]?
    let vote_average: Double
    let vote_count: Int
    let overview: String?
    let backdrop_path: String?
    let poster_path: String?
    
    var dictionary: NSDictionary {
        return ["id": id,
                "title": title as Any ,
                "media_type": media_type as Any,
                "genre_ids": genre_ids as Any,
                "vote_average": vote_average as Any,
                "vote_count": vote_count as Any,
                "overview": overview as Any,
                "backdrop_path": backdrop_path as Any,
                "poster_path": poster_path as Any
                ]
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(backdrop_path)
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
}

struct PeopleMovieResponse: Decodable {
    let cast: [Movie]
    let crew: [Movie]?
    
    var dictionary: NSDictionary {
        return [
            "cast": peopleCastList,
            "crew": peopleCrewList
            ]
    }
    
    var peopleCastList: [NSDictionary] {
        var listCast = [NSDictionary]()
        
        for castObject in cast {
            listCast.append(castObject.dictionary)
        }
        return listCast
    }
    
    var peopleCrewList: [NSDictionary] {
        var listCrew = [NSDictionary]()
        guard let crew = crew else {
            return []
        }

        for crewObject in crew {
            listCrew.append(crewObject.dictionary)
        }
        return listCrew
    }
}

struct PeopleTelevisionResponse: Decodable {
    let cast: [Television]
    let crew: [Television]?
    
    var dictionary: NSDictionary {
        return [
            "cast": peopleCastList,
            "crew": peopleCrewList
            ]
    }
    
    var peopleCastList: [NSDictionary] {
        var listCast = [NSDictionary]()
        
        for castObject in cast {
            listCast.append(castObject.dictionary)
        }
        return listCast
    }
    
    var peopleCrewList: [NSDictionary] {
        var listCrew = [NSDictionary]()
        guard let crew = crew else {
            return []
        }

        for crewObject in crew {
            listCrew.append(crewObject.dictionary)
        }
        return listCrew
    }
}
