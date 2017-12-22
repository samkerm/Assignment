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

    func performSearch( // MediaType can be used as a segment control to switch between the types of content
        for text: String, mediaType type: GPHMediaType = .gif, completion: @escaping (Bool) -> Void)
    {
        state = .loading
        if let client = appDelegate?.client
        {
            client.search(text, media: type )
            { (response, error) in
                if let error = error as NSError? {
                    print(error)
                    completion(false)
                }
                
                // Load the urls from API and once all data is received then fetch all data for each url.
                // Better performance in presentation
                if let response = response, let searchData = response.data, let pagination = response.pagination {
                    print("Results found:", searchData.count)
                    print("Pagination:", pagination.count)
                    var results = [SearchResult]()
                    for result in searchData
                    {
                        if let result = self.parseResults(result: result)
                        {
                            results.append(result)
                        }
                    }
                    var fetchedDataCount = 0
                    for result in results {
                        self.fetchDataFrom(URL: result.gifUrl, completion: { (data, error) in
                            if data != nil {
                                result.gifData = data!
                                fetchedDataCount += 1
                            }
                            if fetchedDataCount == searchData.count {
                                self.state = .results(results)
                                completion(true)
                            }
                        })
                    }
                } else {
                    // Dont give up and fetch for popular items
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
                
                if let response = response, let searchData = response.data, let pagination = response.pagination {
                    print("Results found:", searchData.count)
                    print("Pagination:", pagination.count)
                    var results = [SearchResult]()
                    for result in searchData
                    {
                        if let result = self.parseResults(result: result)
                        {
                            results.append(result)
                        }
                    }
                    var fetchedDataCount = 0
                    for result in results {
                        self.fetchDataFrom(URL: result.gifUrl, completion: { (data, error) in
                            if data != nil {
                                result.gifData = data!
                                fetchedDataCount += 1
                            }
                            if fetchedDataCount == searchData.count {
                                self.state = .results(results)
                                completion(true)
                            }
                        })
                    }
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
            let imageURL = result.images?.original?.gifUrl
        {
            searchResult = SearchResult()
            searchResult?.title         = description
            searchResult?.gifUrl        = imageURL
        }
        return searchResult
    }
    
    fileprivate func fetchDataFrom(URL url: String, completion: @escaping (Data?, Error?) -> Void)
    {
        var downloadTask: URLSessionDownloadTask?
        let session = URLSession.shared

        if let url = URL(string: url)
        {
            downloadTask = session.downloadTask(with: url, completionHandler: { url, response, error in
                if error == nil, let url = url, let data = try? Data(contentsOf: url)
                {
                    completion(data, nil)
                }
                else if error != nil
                {
                    completion(nil, error)
                }
                else
                {
                    completion(nil, nil)
                }
            })
            downloadTask?.resume()
        }
    }
}
