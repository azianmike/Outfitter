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
    var commentController:CommentViewController!
    var storyBoard:UIStoryboard!

    enum ArticleValues: Int {
        case fullOutfit = 0, top, bottom, shoes, accessories
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submissions = [PFObject]()
        currentSubmissionIndex = -1
        genderPickerSelectedIndex = 0
        articlePickerSelectedIndex = 0
        
        storyBoard = UIStoryboard(name: "Main", bundle:nil)

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

        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading Submissions"
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    Global.mergeLists(&self.submissions, listToMerge: objects)
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

    
    @IBAction func goToComments(){
        
        setupCommentController()
        
        self.presentViewController(self.commentController, animated:true, completion:nil)
        
    }
    
    func setupCommentController() {
        
        self.commentController = storyBoard.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        
        self.commentController.setValue(submissions[currentSubmissionIndex].objectId!, forKey: "submissionID")
        
        self.commentController.setValue("false", forKey: "showDelete")
    }
    
}
