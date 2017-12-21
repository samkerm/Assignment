//
//  SearchResultCell.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit
import SwiftyGif

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var gifTitle: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var downloadTask: URLSessionDownloadTask?
    
    @IBAction func addToFavourites(_ sender: Any) {
        favouriteButton.isSelected = !favouriteButton.isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with searchResult: SearchResult) {
        gifTitle.text = searchResult.description
        var newGifView = UIImageView()
        let session = URLSession.shared
        if let url = URL(string: searchResult.gifUrl) {
            downloadTask = session.downloadTask(with: url, completionHandler: { url, response, error in
                if error == nil, let url = url, let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let gifManager = SwiftyGifManager(memoryLimit:20)
                        let image = UIImage(gifData: data)
                        newGifView = UIImageView(gifImage: image, manager: gifManager)
                    }
                } else {
                    DispatchQueue.main.async {
                        let image = UIImage(named: "placeholder-img")
                        newGifView = UIImageView(image: image)
                    }
                }
                
            })
            downloadTask?.resume()
        }
        newGifView.startAnimatingGif()
        newGifView.frame = gifView.frame
        
        self.contentView.addSubview(newGifView)
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
        favouriteButton.isSelected = false
        gifTitle.text = nil
        gifView.image = nil
    }

}
