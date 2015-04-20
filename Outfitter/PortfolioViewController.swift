//
//  PortfolioViewController.swift
//  Outfitter
//
//  Created by Ian Eckles on 3/4/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

public class PortfolioViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationBar!
    var submissions:[PFObject]!
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading Submissions"

        submissions = [PFObject]()
        getSubmissions(doneGettingSubmissions)
    }
    
    func doneGettingSubmissions(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if submissions.count == 0 {
            let alert = UIAlertController(title: "Error", message: "We cannot load your submissions because you do not have any!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.collectionView.reloadData()
        }
    }
    
    func getSubmissions(callback:(()->Void)){
        var query = PFQuery(className:"Submission")
        query.whereKey("submittedByUser", equalTo:PFUser.currentUser().username)
        
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let temp = PFUser.currentUser().objectForKey("name") as! String! {
            navigationBar.topItem?.title = temp + "'s Portfolio"
        } else {
            navigationBar.topItem?.title = PFUser.currentUser().username + "'s Portfolio"
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if submissions == nil {
            return 0
        }
        return submissions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PortfolioCell", forIndexPath: indexPath) as! PortfolioCell
        let temp = SubmissionObject(submissionThing: submissions[indexPath.row])
        cell.setSubmissionObj2(temp)
        //let testNum:String! = submissions[indexPath.row].objectId as String!
        //NSLog(testNum)
        cell.setImage(submissions[indexPath.row].objectForKey("image").url)
        return cell
    }
    
    @IBAction func closePortfolio(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PortfolioCell
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let submissionViewController: UIViewController! = storyBoard.instantiateViewControllerWithIdentifier("PortfolioSubmissionViewController") as! UIViewController
        submissionViewController.setValue(cell.imageView.image, forKey: "image")
        submissionViewController.setValue(cell.submissionObj, forKey: "submissionObj")
        
        self.presentViewController(submissionViewController, animated:true, completion:nil)
    }

}