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

    @IBOutlet weak var gifTitle: UILabel!
    @IBOutlet weak var gifView: UIImageView!

    var newGifView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with gif: GIF) {
        gifTitle.text = gif.title
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let image = UIImage(gifData: gif.gifData, levelOfIntegrity:0.1)
        self.newGifView = UIImageView(gifImage: image, manager: gifManager)
        self.newGifView?.startAnimatingGif()
        self.newGifView?.frame = self.gifView.frame
        self.contentView.addSubview(self.newGifView!)
        
    }
    
    override func prepareForReuse() {
        gifTitle.text = nil
        self.newGifView?.removeFromSuperview()
    }

}
