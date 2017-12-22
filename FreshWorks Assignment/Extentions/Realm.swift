//
//  Realm.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-21.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit
import RealmSwift

extension Realm
{
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
