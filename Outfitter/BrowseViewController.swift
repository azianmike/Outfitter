//
//  BrowseViewController.swift
//  Outfitter
//
//  Created by Yusuf Sobh on 3/16/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    var submissions:[PFObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        getSubmissions(doneGettingSubmissions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneGettingSubmissions(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if submissions.count == 0 {
            let alert = UIAlertController(title: "Error", message: "No submissions Available", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            // ** Example Test Code -- Replace with implementation **
            if var submissionExample = submissions.first {
                var numLikes: AnyObject! = submissionExample.objectForKey("numLikes")
                submissionExample.setObject(numLikes.integerValue + 1, forKey: "numLikes")
                updateSubmission(submissionExample, completionHandler: { (result) -> Void in
                    NSLog("Updated submission")
                })
            }
            
            //self.collectionView.reloadData()
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
