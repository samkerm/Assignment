//
//  UIImageView.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//
import UIKit

extension UIImageView {
    func loadImageWithURL(_ url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = UIImage(named: "placeholder-img")
                    }
                }
            }
            
        })
        downloadTask.resume()
        return downloadTask
    }
    
    func applyImageWithURL(_ url: URL) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = UIImage(named: "placeholder-img")
                    }
                }
            }
            
        })
        downloadTask.resume()
    }
}
