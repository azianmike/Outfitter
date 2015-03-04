//
//  PortfolioCell.swift
//  Outfitter
//
//  Created by Ian Eckles on 3/4/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class PortfolioCell: UICollectionViewCell {
    @IBOutlet var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func setImage(imageURL:NSString){
        let url = NSURL(string: imageURL)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        imageView.image = image!
        NSLog(NSStringFromCGSize(image!.size))
    }
}
