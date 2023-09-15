//
//  LanguageModel.swift
//  VideoPlayer
//
//  Created by Quynh Nguyen on 13/06/2022.
//

import Foundation

struct LanguageModel: Encodable, Decodable {
    let code: String
    let name: String
    let id: String
}

extension Encodable {
    func toJSONString() -> String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

func instantiate<T: Decodable>(jsonString: String) -> T? {
    return try? JSONDecoder().decode(T.self, from: jsonString.data(using: .utf8)!)
}

func getLanguages() -> [LanguageModel] {
    do {
        guard let jsonData = kCountries.data(using: .utf8) else {
            return []
        }
        
        let json = try JSONDecoder().decode([LanguageModel].self, from: jsonData)
        return json
    } catch {
        return []
    }
}

let englishLanguage = LanguageModel(code: "en", name: "English", id: "sublanguageid-eng")

let kCountries = """
[
    {
      "code": "ar",
      "name": "Arabic",
      "id": "sublanguageid-ara"
    },
    {
      "code": "zh",
      "name": "Chinese",
      "id": "sublanguageid-chi"
    },
    {
      "code": "hr",
      "name": "Croatian",
      "id": "sublanguageid-hrv"
    },
    {
      "code": "nl",
      "name": "Dutch",
      "id": "sublanguageid-dut"
    },
    {
      "code": "no",
      "name": "Norwegian",
      "id": "sublanguageid-nor"
    },
    {
      "code": "en",
      "name": "English",
      "id": "sublanguageid-eng"
    },
    {
      "code": "fr",
      "name": "French",
      "id": "sublanguageid-fre"
    },
    {
      "code": "de",
      "name": "German",
      "id": "sublanguageid-ger"
    },
    {
      "code": "el",
      "name": "Greek",
      "id": "sublanguageid-ell"
    },
    {
      "code": "he",
      "name": "Hebrew",
      "id": "sublanguageid-heb"
    },
    {
      "code": "it",
      "name": "Italian",
      "id": "sublanguageid-ita"
    },
    {
      "code": "id",
      "name": "Indonesia",
      "id": "sublanguageid-ind"
    },
    {
      "code": "ja",
      "name": "Japanese",
      "id": "sublanguageid-jpn"
    },
    {
      "code": "la",
      "name": "Latin",
      "id": "sublanguageid-lav"
    },
    {
      "code": "pl",
      "name": "Polish",
      "id": "sublanguageid-pol"
    },
    {
      "code": "pt",
      "name": "Portuguese",
      "id": "sublanguageid-por"
    },
    {
      "code": "ro",
      "name": "Romanian",
      "id": "sublanguageid-rum"
    },
    {
      "code": "ru",
      "name": "Russian",
      "id": "sublanguageid-rus"
    },
    {
      "code": "es",
      "name": "Spanish",
      "id": "sublanguageid-spa"
    },
    {
      "code": "sr",
      "name": "Serbian",
      "id": "sublanguageid-scc"
    },
    {
      "code": "sv",
      "name": "Swedish",
      "id": "sublanguageid-swe"
    },
    {
      "code": "th",
      "name": "Thai",
      "id": "sublanguageid-tha"
    },
    {
      "code": "tr",
      "name": "Turkish",
      "id": "sublanguageid-tur"
    },
    {
      "code": "ukr",
      "name": "Ukrainian",
      "id": "sublanguageid-ukr"
    },
    {
      "code": "vi",
      "name": "Vietnamese",
      "id": "sublanguageid-vie"
    }
  ]
"""
