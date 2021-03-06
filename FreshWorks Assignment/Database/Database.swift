//
//  Database.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-21.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import Foundation
import RealmSwift


class Database
{
    private static var _realm: Realm? = nil
    private static let isNotDeleted = "isDeleted == false"
    private static let isNotUploaded = "isUploaded != true"
    
    static var realm: Realm {
        get {
            // Checks if realm has been initialized, if it hasn't initialize it.
            if _realm == nil,
                let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.setupDatabase()
            }
            return _realm!
        }
        set {
            _realm = newValue
        }
    }
    
    /// Save Entity
    class func saveEntities(entities: [Object]) {
        try! realm.safeWrite {
            realm.add(entities, update: true)
        }
    }
    
    /// Delete Entity
    class func delete(entities: [Object]) {
        try! realm.safeWrite {
            realm.delete(entities)
        }
    }
    
    // Delete entity by id
    class func delete(by id: String)
    {
        if let entity = realm.objects(GIF.self).filter("id == '\(id)'").first {
            try! realm.safeWrite {
                realm.delete(entity)
            }
        }
        else
        {
            print("Could not delete entity with id \(id)")
        }
    }
    
    // Get all GIFs
    class func getAllGIFs() -> [GIF] {
        return realm.objects(GIF.self).map{$0}
    }
}
