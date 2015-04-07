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
    var submissionObj: SubmissionObject!
    
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
    }
    
    func setSubmissionObj(submissionObj:SubmissionObject)
    {
        self.submissionObj=submissionObj
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("clicked portfolio cell inside portfolio cell")
    }
    
}

class SubmissionObject:NSObject{
    var numLikes:Int!
    var numDislikes:Int!
    var image:UIImage!
    var objectID:String!
    
    init(submissionThing:PFObject){
        super.init()
        NSLog("enter")
        NSLog(submissionThing.objectForKey("objectId")! as String)
        objectID = submissionThing.objectForKey("objectId")! as String
        numLikes = submissionThing.objectForKey("numLikes")! as Int
        numDislikes = submissionThing.objectForKey("numDislikes")! as Int
        image = setImage(submissionThing.objectForKey("image").url)
    }
    
    internal func setImage(imageURL:NSString)->UIImage{
        let url = NSURL(string: imageURL)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
    func getLikes()-> Int{
        return numLikes!
    }
    
    func getDislikes()-> Int{
        return numDislikes!
    }
    
    func getObjectID()-> String{
        return objectID!
    }
    
}
