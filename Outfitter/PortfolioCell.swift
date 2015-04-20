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
        let url = NSURL(string: imageURL as String)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        imageView.image = image!
    }
    
    func setSubmissionObj2(submissionObj:SubmissionObject)
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
    var article: Int!
    var maleFeedback: Bool!
    var femaleFeedback: Bool!
    
    init(submissionThing:PFObject){
        super.init()
        NSLog("enter")
        //NSLog(submissionThing.objectForKey("objectId")! as String)
        objectID = submissionThing.objectId
        article = submissionThing.objectForKey("article")! as! Int
        numLikes = submissionThing.objectForKey("numLikes")! as! Int
        numDislikes = submissionThing.objectForKey("numDislikes")! as! Int
        image = setImage2(submissionThing.objectForKey("image").url)
        maleFeedback = submissionThing.objectForKey("toReceiveMaleFeedback") as! Bool
        femaleFeedback = submissionThing.objectForKey("toReceiveFemaleFeedback") as! Bool
    }
    
    internal func setImage2(imageURL:NSString)->UIImage{
        let url = NSURL(string: imageURL as String)
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
    
    func getArticle()-> Int{
        return article
    }
    
    func getMaleFeedback()-> Bool!{
        return maleFeedback
    }
    func getFemaleFeedback()-> Bool!{
        return femaleFeedback
    }
    
}
