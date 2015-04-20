//
//  SubmitPhotoViewController.swift
//  Outfitter
//
//  Created by Michael Luo on 3/2/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

public class SubmitPhotoViewController: UIViewController {
    
    
    var imageToSubmit:UIImage!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var article:UISegmentedControl!
    @IBOutlet var guysOrGirls:UISegmentedControl!
    @IBOutlet var priority:UISegmentedControl!
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        imageToSubmit = self.valueForKey("imageToSubmit") as! UIImage
         NSLog("got my image")
        imageView.image = imageToSubmit
        
        
        
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPhoto()
    {
        var articleID:Int = article.selectedSegmentIndex
        var femaleFeedback:Bool
        var maleFeedback:Bool
        if guysOrGirls.selectedSegmentIndex == 0{
            femaleFeedback = true
            maleFeedback = true
        } else if guysOrGirls.selectedSegmentIndex == 1{
            femaleFeedback = false
            maleFeedback = true
        } else {
            femaleFeedback = true
            maleFeedback = false
        }
        var submitPriority:Bool
        if priority.selectedSegmentIndex == 0{
            submitPriority = false
        } else {
            submitPriority = true
        }
        
        submitPhotoToParse(imageToSubmit, articleID: articleID, femaleFeedback: femaleFeedback, maleFeedback: maleFeedback, submitPriority: submitPriority)
    }
    
    func submitPhotoToParse(image:UIImage, articleID:Int, femaleFeedback:Bool, maleFeedback:Bool, submitPriority:Bool, completionHandler: ((result:Bool) -> Void)! = nil){
        var submission = PFObject(className: "Submission")
        
        // Deal with UIImage not saving to Parse
        var imageData:NSData = UIImageJPEGRepresentation(imageToSubmit, 0.40)
        var imageFile:PFFile = PFFile(name: "submissionImage.png", data: imageData)
        
        submission.setObject(imageFile, forKey: "image")
        submission.setObject(articleID, forKey: "article")
        submission.setObject(submitPriority, forKey: "isPrioritySubmission")
        submission.setObject(0, forKey: "numDislikes")
        submission.setObject(0, forKey: "numLikes")
        submission.setObject(PFUser.currentUser().username, forKey: "submittedByUser")
        submission.setObject(femaleFeedback, forKey: "toReceiveFemaleFeedback")
        submission.setObject(maleFeedback, forKey: "toReceiveMaleFeedback")
        
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
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                NSLog("%@", error)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "There was an error when submitting you image...Please try again soon!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
  
    @IBAction func cancelSubmit()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
