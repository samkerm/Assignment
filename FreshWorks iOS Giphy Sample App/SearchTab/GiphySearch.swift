//
//  GiphySearch.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import Foundation
import GiphyCoreSDK

open class Search {
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    fileprivate(set) var state = State.notSearchedYet
    fileprivate var appDelegate: AppDelegate?
    
    init(state: State) {
        self.state = state
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
        }
    }

    func performSearch(
        for text: String, mediaType type: GPHMediaType = .gif, completion: @escaping (Bool) -> Void)
    {
        if let client = appDelegate?.client
        {
            client.search(text, media: type )
            { (response, error) in
                if let error = error as NSError? {
                    print(error)
                    completion(false)
                }
                
                if let response = response, let data = response.data, let pagination = response.pagination {
                    print("Results found:", data.count)
                    print("Pagination:", pagination.count)
                    var results = [SearchResult]()
                    for result in data {
                        if let result = self.parseResults(result: result)
                        {
                            results.append(result)
                        }
                    }
                    self.state = .results(results)
                    completion(true)
                } else {
                    self.performTrendingSearch(mediaType: type, completion: { (success) in
                        completion(success)
                    })
                }
            }
        }
    }
    
    private func performTrendingSearch(
        mediaType type: GPHMediaType = .gif, completion: @escaping (Bool) -> Void)
    {
        if let client = appDelegate?.client
        {
            client.trending(type )
            { (response, error) in
                if let error = error as NSError? {
                    print(error)
                    completion(false)
                }
                
                if let response = response, let data = response.data, let pagination = response.pagination {
                    print("Results found:", data.count)
                    print("Pagination:", pagination.count)
                    var results = [SearchResult]()
                    for result in data
                    {
                        if let result = self.parseResults(result: result)
                        {
                            results.append(result)
                        }
                    }
                    self.state = .results(results)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    fileprivate func parseResults(result: GPHMedia) -> SearchResult?
    {
        var searchResult: SearchResult?
        if let description = result.title,
            let image = result.images?.original
        {
            searchResult = SearchResult()
            searchResult?.description   = description
            searchResult?.gifUrl        = image.gifUrl ?? ""
            searchResult?.mp4Url        = image.mp4Url ?? ""
        }
        return searchResult
    }
}
