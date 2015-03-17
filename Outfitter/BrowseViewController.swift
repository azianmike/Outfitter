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
            
            sender.setTitle(value as String!, forState: UIControlState.Normal)
            self.genderPickerSelectedIndex = index
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func showArticlePicker(sender: UIButton!){
        ActionSheetStringPicker.showPickerWithTitle("Articles", rows: ["Full Outfits", "Tops", "Bottoms", "Shoes", "Accessories"], initialSelection: self.articlePickerSelectedIndex, doneBlock: {
            picker, index, value in
            
            sender.setTitle(value as String!, forState: UIControlState.Normal)
            self.articlePickerSelectedIndex = index
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func go(){
        submissions.removeAll(keepCapacity: false)
        getSubmissions(doneGettingSubmissions)
    }
    
    @IBAction func closeBrowse(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadCurrentPicture(){
        if currentSubmissionIndex >= 0 && currentSubmissionIndex < submissions.count {
            var imageURL:NSString = submissions[currentSubmissionIndex].objectForKey("image").url
            let url = NSURL(string: imageURL)
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
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right: // yes
                    NSLog("Swiped right")
                    submissions[currentSubmissionIndex]["numLikes"] = submissions[currentSubmissionIndex].objectForKey("numLikes") as Int! + 1
                case UISwipeGestureRecognizerDirection.Left: // no
                    NSLog("Swiped left")
                    submissions[currentSubmissionIndex]["numDislikes"] = submissions[currentSubmissionIndex].objectForKey("numDislikes") as Int! + 1
                default:
                    break
                }
                //updateSubmission(submissions[currentSubmissionIndex])
                // Need the code to add the vote to the RatingActivity table
                
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
    
    func getSubmissions(callback:(()->Void)){
        var query = PFQuery(className:"Submission")
        query.whereKey("submittedByUser", notEqualTo:PFUser.currentUser().username)
        
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
    
    // Call this after updating the submission object
    func updateSubmission(submission:PFObject, completionHandler: ((result:Bool) -> Void)! = nil){
        
        submission.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            
            if((completionHandler) != nil) {
                completionHandler(result: success)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

            if success {
                NSLog("Object updated with id: \(submission.objectId)")
            } else {
                NSLog("%@", error)
                let alert = UIAlertController(title: "Error", message: "There was an error when submitting you image...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

}
