//
//  SavedViewCell.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-22.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit
import SwiftyGif

class SavedViewCell: UICollectionViewCell {

    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var gifTitle: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewPlatform: UIView!
    
    var newGifView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with gif: GIF)
    {
        
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let image = UIImage(gifData: gif.gifData)
        newGifView = UIImageView(gifImage: image, manager: gifManager)
        newGifView?.startAnimatingGif()
        newGifView?.frame = gifView.frame
        viewPlatform.insertSubview(newGifView!, at: 1)
        contentView.bringSubview(toFront: deleteButton)
        
        gifTitle!.text = gif.title
        
        contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
    override func prepareForReuse() {
        gifTitle?.text = nil
        newGifView?.removeFromSuperview()
    }

}
