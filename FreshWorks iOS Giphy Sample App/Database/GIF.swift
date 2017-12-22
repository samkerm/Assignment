//
//  GIF.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-21.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit
import RealmSwift

class GIF: Object
{
    
    @objc dynamic var id            = Mongo.id() // Use Mongo format for better compatibility with commonly used mongodb
    @objc dynamic var title         = ""
    @objc dynamic var gifUrl        = ""
    @objc dynamic var gifData       = Data()
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    convenience init(from searchResult: SearchResult)
    {
        self.init()
        title   = searchResult.title
        gifUrl  = searchResult.gifUrl
        gifData = searchResult.gifData
    }
}
