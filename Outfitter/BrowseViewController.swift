//
//  BrowseViewController.swift
//  Outfitter
//
//  Created by Yusuf Sobh on 3/16/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    @IBOutlet var genderButton:UIButton!
    @IBOutlet var articleButton:UIButton!
    @IBOutlet var currentImageView:UIImageView!
    var submissions:[PFObject]!
    var genderPickerSelectedIndex:Int!
    var articlePickerSelectedIndex:Int!
    var currentSubmissionIndex:Int!
    
    enum ArticleValues: Int {
        case fullOutfit = 0, top, bottom, shoes, accessories
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submissions = [PFObject]()
        currentSubmissionIndex = -1
        genderPickerSelectedIndex = 0
        articlePickerSelectedIndex = 0
        
        //Setup swipe
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "userSwiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipLeft = UISwipeGestureRecognizer(target: self, action: "userSwiped:")
        swipLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipLeft)
        
        go()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGenderPicker(sender: UIButton!){
        ActionSheetStringPicker.showPickerWithTitle("Gender", rows: ["Male", "Female", "Both Male and Female"], initialSelection: self.genderPickerSelectedIndex, doneBlock: {
            picker, index, value in
            
            sender.setTitle(value as! String!, forState: UIControlState.Normal)
            self.genderPickerSelectedIndex = index
            
            //self.filterByGender()
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func showArticlePicker(sender: UIButton!){
        ActionSheetStringPicker.showPickerWithTitle("Articles", rows: ["Full Outfits", "Tops", "Bottoms", "Shoes", "Accessories"], initialSelection: self.articlePickerSelectedIndex, doneBlock: {
            picker, index, value in
            
            sender.setTitle(value as! String!, forState: UIControlState.Normal)
            self.articlePickerSelectedIndex = index
            
            self.filterByArticle(value as! String!)

            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    /*func filterByGender()
    {
        submissions.removeAll(keepCapacity: false)
        getSubmissions(doneGettingSubmissions,articleId: articlePickerSelectedIndex)
    }*/
    
    func filterByArticle(article: String) {
        
        var articleID:Int
        
        switch article {
            case "Full Outfits":
                articleID = ArticleValues.fullOutfit.rawValue
            case "Tops":
                articleID = ArticleValues.top.rawValue
            case "Bottoms":
                articleID = ArticleValues.bottom.rawValue
            case "Shoes":
                articleID = ArticleValues.shoes.rawValue
            case "Accessories":
                articleID = ArticleValues.accessories.rawValue
        default:
            articleID = -1
        }
        
        submissions.removeAll(keepCapacity: false)
        getSubmissions(doneGettingSubmissions,articleId: articleID)
    }
    
    @IBAction func go(){
        submissions.removeAll(keepCapacity: false)
        getSubmissions(doneGettingSubmissions, articleId: articlePickerSelectedIndex)
    }
    
    @IBAction func closeBrowse(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadCurrentPicture(){
        if currentSubmissionIndex >= 0 && currentSubmissionIndex < submissions.count {
            var imageURL:NSString = submissions[currentSubmissionIndex].objectForKey("image").url
            let url = NSURL(string: imageURL as String)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            currentImageView.image = image!
        } else {
            currentImageView.image = nil
            
            let alert = UIAlertController(title: "Error", message: "No submissions Available", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func userSwiped(gesture: UIGestureRecognizer) {
        if currentSubmissionIndex >= 0 && currentSubmissionIndex < submissions.count {
            var curObj = submissions[currentSubmissionIndex]
            
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right: // yes
                    NSLog("Swiped right")
                    self.submitRatingActivity(curObj.objectId, userId: PFUser.currentUser().objectId, votedYes: true, completionHandler: nil)
                case UISwipeGestureRecognizerDirection.Left: // no
                    NSLog("Swiped left")
                    self.submitRatingActivity(curObj.objectId, userId: PFUser.currentUser().objectId, votedYes: false, completionHandler: nil)
                default:
                    break
                }
                
                currentSubmissionIndex = currentSubmissionIndex + 1
                loadCurrentPicture()
            }
        }
    }
    
    func doneGettingSubmissions(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        NSLog(String(submissions.count))
        if submissions.count == 0 {
            let alert = UIAlertController(title: "Error", message: "No submissions Available", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // We have submissions
            self.currentSubmissionIndex = 0
            loadCurrentPicture()
        }
    }
    
    func getSubmissions(callback:(()->Void),articleId:Int = -1){
        var query = PFQuery(className:"Submission")
        query.whereKey("submittedByUser", notEqualTo:PFUser.currentUser().username)
        
        var ratingQuery = PFQuery(className:"RatingActivity")
        
        //query where there is no rating activity associated with submission
        query.whereKey("objectId", doesNotMatchKey: "submissionId", inQuery: ratingQuery)
        
        if let gender = PFUser.currentUser().objectForKey("gender") as? String {
            if(gender == "male") {
                query.whereKey("toReceiveMaleFeedback", equalTo: true)
            } else {
                query.whereKey("toReceiveFemaleFeedback", equalTo: true)
            }
        }

        if(articleId >= 0) {
            query.whereKey("article", equalTo:articleId)
        }
        
        /*if(genderPickerSelectedIndex == 0){
            query.whereKey("genderOfSubmitter", equalTo:"male")
        } else if (genderPickerSelectedIndex == 1){
            query.whereKey("genderOfSubmitter", equalTo:"female")
        }*/

        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading Submissions"
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.submissions.append(object)
                    }
                }
                callback()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
                callback()
            }
        }
    }
    
    func submitRatingActivity(submissionId:String, userId:String, votedYes:Bool, completionHandler: ((result:Bool) -> Void)! = nil){
        var submission = PFObject(className: "RatingActivity")
        submission.setObject(submissionId, forKey: "submissionId")
        submission.setObject(userId, forKey: "userId")
        submission.setObject(votedYes, forKey: "votedYes")
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Saving Submission"
        
        submission.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            
            if((completionHandler) != nil) {
                completionHandler(result: success)
            }
            
            if success {
                NSLog("Object created with id: \(submission.objectId)")
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            } else {
                NSLog("%@", error)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when submitting your rating...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
        }
    }
    
    // The callback function is optional, it will be called when the comment is finally saved and it will be passed the new comments objectId
    func addComment(commentString:String, submissionId:String, userId:String, callback:((objectId: String)->Void)! = nil){
        var comment = PFObject(className: "Comment")
        comment.setObject(submissionId, forKey: "submissionId")
        comment.setObject(userId, forKey: "userId")
        comment.setObject(commentString, forKey: "comment")
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Saving Comment"
        
        comment.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                if ((callback) != nil){
                    callback(objectId: comment.objectId)
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            } else {
                NSLog("%@", error!)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when submitting your comment...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
        }
    }
    
    // The delete and upvote functions need to be moved to the new view
    func deleteComment(commentId:String){
        var query = PFQuery(className:"Comment")
        query.whereKey("objectId", equalTo: commentId)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Deleting Comment"
        
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
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            } else {
                                NSLog("%@", error!)
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                let alert = UIAlertController(title: "Error", message: "There was an error when deleting your comment...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            }
                        }
                    }
                }
            } else {
                NSLog("%@", error!)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when deleting your comment...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
        }
    }
    
    func upvoteComment(commentId:String, userId:String, callback:((objectId: String)->Void)! = nil){
        var vote = PFObject(className: "CommentActivity")
        vote.setObject(commentId, forKey: "commentId")
        vote.setObject(userId, forKey: "userId")
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Upvoting Comment"

        
        vote.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                if ((callback) != nil){
                    callback(objectId: vote.objectId)
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            } else {
                NSLog("%@", error!)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when submitting your upvote...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            }
        }
    }
}
