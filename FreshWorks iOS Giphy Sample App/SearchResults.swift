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
    var title = ""
    var year = ""
    var imdbID = ""
    var type = ""
    var poster = ""
    
    
    //    ------------------Variables from a Title specific search---------
    var rated = ""
    var released = ""
    var runtime = ""
    var genre = ""
    var director = ""
    var writer = ""
    var actors = ""
    var plot = ""
    var language = ""
    var country = ""
    var awards = ""
    var metascore = ""
    var imdbRating = ""
    var production = ""
    var website = ""
    var response = ""
    var error = ""
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}
