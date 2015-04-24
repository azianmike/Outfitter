//
//  BasicCell.swift
//  Outfitter
//
//  Created by Michael Luo on 4/21/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell, UIAlertViewDelegate{
    
    var parentViewController:UIViewController!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deleteButton:UIButton!
    @IBOutlet var upvoteButton:UIButton!
    @IBOutlet var upvoteCount:UILabel!
    var commentID: String!
    var upvoteNumber:Int!
    var userName:String!
    
    func deleteComment(commentId:String, callback:(()->Void)){
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
                                callback()
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
    
    func getAndSetUsername(){
        getUserName(subtitleLabel.text!, callback:setUsername)
    }
    
    func setUsername()
    {
        subtitleLabel.text=userName
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
        var query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: userId)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if let objects = objects[0] as? PFObject {
                println("objects is not null")
                println(objects.objectId)
                //for object in objects {
                    self.userName = objects.valueForKey("username") as! String

                    callback()
                    //break
                //}
            }else{
            }
            
        }
    }
    
    @IBAction func deleteComment()
    {
        deleteComment(commentID, callback: dismissView)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0 && alertView.title == "Successfully deleted comment!")
        {
            parentViewController.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    func dismissView()
    {
        showAlertView("Successfully deleted comment!")

            }
    
    func showAlertView(titleString: String)
    {
        var tempAlertView = UIAlertView(title: titleString, message: "Success!", delegate: self,
            cancelButtonTitle: "Cancel")
        tempAlertView.show()
    }
    
    @IBAction func upvoteComment()
    {
        upvoteComment(commentID, userId: PFUser.currentUser().objectId, callback: showUpvoteAlert)
    }
    
    func showUpvoteAlert()
    {
        showAlertView("Successfully upvoted comment!")
    }
    
    func upvoteComment(commentId:String, userId:String, callback:(()->Void)! = nil){
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
                            callback()
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
