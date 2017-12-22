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
    var newGifView: UIImageView?

    @IBAction func addToFavourites(_ sender: Any) {
        favouriteButton.isSelected = !favouriteButton.isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "placeholder-img")
        newGifView = UIImageView(image: image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with searchResult: SearchResult) {
        gifTitle.text = searchResult.description
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let image = UIImage(gifData: searchResult.gifData, levelOfIntegrity:0.1)
        self.newGifView = UIImageView(gifImage: image, manager: gifManager)
        self.newGifView?.startAnimatingGif()
        self.newGifView?.frame = self.gifView.frame
        self.contentView.addSubview(self.newGifView!)
        
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
        favouriteButton.isSelected = false
        gifTitle.text = nil
        self.newGifView?.removeFromSuperview()
    }

}
