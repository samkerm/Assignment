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
    
    var newGifView: UIImageView?
    var gif: GIF?

    @IBAction func addToFavourites(_ sender: Any)
    {
        if let gif = gif
        {
            favouriteButton.isSelected = !favouriteButton.isSelected
            if (favouriteButton.isSelected)
            {
                // Due to Realm restrictions we need to check the file size for storage
                let test = gif.gifData as NSData
                if test.length < 15000000 {
                    Database.saveEntities(entities: [gif])
                } else {
                    print("file too big to save")
                    favouriteButton.isSelected = false
                }
            }
            else
            {
                Database.delete(entities: [gif])
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with searchResult: SearchResult)
    {
        gif = GIF(from: searchResult)
        gifTitle.text = searchResult.title
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let image = UIImage(gifData: searchResult.gifData)
        self.newGifView = UIImageView(gifImage: image, manager: gifManager)
        self.newGifView?.startAnimatingGif()
        self.newGifView?.frame = self.gifView.frame
        self.contentView.addSubview(self.newGifView!)
        
    }
    
    override func prepareForReuse()
    {
        favouriteButton.isSelected = false
        gifTitle.text = nil
        self.newGifView?.removeFromSuperview()
    }

}
