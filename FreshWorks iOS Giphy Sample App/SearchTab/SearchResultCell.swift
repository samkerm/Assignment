//
//  SearchResultCell.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with searchResult: SearchResult) {
        gifTitle.text = searchResult.description
        if let url = URL(string: searchResult.gifUrl) {
            downloadTask = gifView.loadImageWithURL(url)
        }
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
        favouriteButton.isSelected = false
        gifTitle.text = nil
        gifView.image = nil
    }

}
