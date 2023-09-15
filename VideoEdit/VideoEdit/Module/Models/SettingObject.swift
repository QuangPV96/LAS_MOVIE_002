//
//  SettingObject.swift
//  Movie
//
//  Created by quang on 08/08/2023.
//

import RealmSwift

class SettingObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
