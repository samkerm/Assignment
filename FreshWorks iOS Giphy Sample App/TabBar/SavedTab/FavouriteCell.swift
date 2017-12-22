//
//  FavouriteCell.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-21.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit
import SwiftyGif

class FavouriteCell: UITableViewCell {

    var newGifView: UIImageView?
    var gifTitle: UILabel?
    var platformView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with gif: GIF)
    {
        // Create subviews you
        platformView = UIView(frame: CGRect(x: 0, y: 10 , width: bounds.width, height: bounds.height - 10))
        platformView!.backgroundColor = .white
        contentView.addSubview(platformView!)
        
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let image = UIImage(gifData: gif.gifData)
        newGifView = UIImageView(gifImage: image, manager: gifManager)
        newGifView?.startAnimatingGif()
        newGifView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 60)
        platformView!.addSubview(newGifView!)
        
        gifTitle = UILabel(frame: CGRect(x: 10, y: bounds.height - 60, width: bounds.width - 10, height: 60))
        gifTitle!.text = gif.title
        gifTitle!.textAlignment = .justified
        platformView!.addSubview(gifTitle!)
        
        contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
    override func prepareForReuse() {
        gifTitle?.removeFromSuperview()
        platformView?.removeFromSuperview()
        newGifView?.removeFromSuperview()
    }

}
