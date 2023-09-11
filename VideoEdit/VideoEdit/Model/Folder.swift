//
//  Folder.swift
//  VideoEdit
//
//  Created by apple on 15/08/2023.
//

import Foundation
class Folder: NSObject {
    var name: String = ""
    var count: String = ""
    var list: [VideoModel]!
    
    init(name: String, count: String, list: [VideoModel]!) {
        self.name = name
        self.count = count
        self.list = list
    }
    override init() {
        
    }
}
