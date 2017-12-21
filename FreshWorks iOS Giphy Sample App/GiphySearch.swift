//
//  GiphySearch.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import Foundation
import GiphyCoreSDK

class Search {
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    fileprivate(set) var state: State = .notSearchedYet
    fileprivate let appDelegate = AppDelegate()

    func performSearch(
        for text: String, mediaType type: GPHMediaType = .gif, completion: @escaping (Bool) -> Void)
    {
        if let client = appDelegate.client
        {
            let op = client.search(text, media: type )
            { (response, error) in
                if let error = error as NSError? {
                    // Do what you want with the error
                    print(error)
                }
                
                if let response = response, let data = response.data, let pagination = response.pagination {
                    print(response.meta)
                    print(pagination)
                    for result in data {
                        print(result)
                        //self.state = .results(searchResults)
                    }
                } else {
                    print("No Results Found")
                }
            }
            print(op)
        }
    }
    
    func performTrendingSearch(
        mediaType type: GPHMediaType = .gif, completion: @escaping (Bool) -> Void)
    {
        if let client = appDelegate.client
        {
            let op = client.trending(type )
            { (response, error) in
                if let error = error as NSError? {
                    // Do what you want with the error
                    print(error)
                }
                
                if let response = response, let data = response.data, let pagination = response.pagination {
                    print(response.meta)
                    print(pagination)
                    for result in data {
                        print(result)
                        //self.state = .results(searchResults)
                    }
                } else {
                    print("No Results Found")
                }
            }
            print(op)
        }
    }
}
