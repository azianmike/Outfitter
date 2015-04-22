//
//  BasicCell.swift
//  Outfitter
//
//  Created by Michael Luo on 4/21/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deleteButton:UIButton!
    @IBOutlet var upvoteButton:UIButton!
    @IBOutlet var upvoteCount:UILabel!
    var commentID: String!
    var upvoteNumber:Int!
    var userName:String!
    
    func deleteComment(commentId:String){
        var query = PFQuery(className:"Comment")
        query.whereKey("objectId", equalTo: commentId)
        
        //let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //loadingNotification.mode = MBProgressHUDModeIndeterminate
        //loadingNotification.labelText = "Deleting Comment"
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        // Now to delete all the upvotes
                        var voteQuery = PFQuery(className: "CommentActivity")
                        voteQuery.whereKey("commentId", equalTo: object.objectId)
                        
                        voteQuery.findObjectsInBackgroundWithBlock{
                            (objects2: [AnyObject]!, error2: NSError!) -> Void in
                            if error2 == nil{
                                if let objects2 = objects2 as? [PFObject] {
                                    for object2 in objects2 {
                                        object2.delete()
                                    }
                                }
                                object.delete()
                                //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            } else {
                                NSLog("%@", error!)
                                //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                let alert = UIAlertController(title: "Error", message: "There was an error when deleting your comment...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            }
                        }
                    }
                }
            } else {
                NSLog("%@", error!)
                //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when deleting your comment...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
        }
        
    }
    
    func getAndSetUpvote(){
        getUpvoteNumber(setUpvoteLabel)
    }
    
    func setUpvoteLabel()
    {
        upvoteCount.text = String(upvoteNumber)
    }
    
    func getUpvoteNumber(callback:(()->Void)){
        var query = PFQuery(className: "CommentActivity")
        query.whereKey("commentId", equalTo: commentID)
        upvoteNumber = 0
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if let objects = objects as? [PFObject] {
                for object in objects {
                    self.upvoteNumber = self.upvoteNumber + 1
                }
            }
            callback()
        }
    }
    
    func getUserName(userId:String, callback:(()->Void)){
        var query = PFQuery(className: "User")
        query.whereKey("objectId", equalTo: userId)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if let objects = objects as? [PFObject] {
                for object in objects {
                    self.userName = object.valueForKey("username") as! String
                    break
                }
            }
            callback()
        }
    }
    
    @IBAction func deleteComment()
    {
        println("Clicked delete")
        deleteComment(commentID)
    }
    
    @IBAction func upvoteComment()
    {
        upvoteComment(commentID, userId: PFUser.currentUser().objectId, callback: nil)
    }
    
    func upvoteComment(commentId:String, userId:String, callback:((objectId: String)->Void)! = nil){
        var query = PFQuery(className: "CommentActivity")
        query.whereKey("userId", equalTo: userId)
        query.whereKey("commentId", equalTo: commentId)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            var count = 0
            if let objects = objects as? [PFObject] {
                for object in objects {
                    count = count + 1
                }
            }
            if (count == 0){
                var vote = PFObject(className: "CommentActivity")
                vote.setObject(commentId, forKey: "commentId")
                vote.setObject(userId, forKey: "userId")
                
                //let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                //loadingNotification.mode = MBProgressHUDModeIndeterminate
                //loadingNotification.labelText = "Upvoting Comment"
                
                
                vote.saveInBackgroundWithBlock{
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        if ((callback) != nil){
                            callback(objectId: vote.objectId)
                        }
                        //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    } else {
                        NSLog("%@", error!)
                        //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        let alert = UIAlertController(title: "Error", message: "There was an error when submitting your upvote...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
