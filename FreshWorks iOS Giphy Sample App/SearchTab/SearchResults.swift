//
//  SearchResults.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import Foundation

class SearchResult {
    //    ------------------Variables from searching a title---------------
    var description = ""
    var gifUrl = ""
    var mp4Url = ""
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.description.localizedStandardCompare(rhs.description) == .orderedAscending
}
