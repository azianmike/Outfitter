//
//  PortfolioViewController.swift
//  Outfitter
//
//  Created by Ian Eckles on 3/4/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

public class PortfolioViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationBar!
    var submissions:[PFObject]!
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        navigationBar.topItem?.title = PFUser.currentUser().objectForKey("name") as String! + "'s Portfolio"
        var query = PFQuery(className:"Submission")
        query.whereKey("submittedByUser", equalTo:PFUser.currentUser().username)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading Submissions"
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.submissions = [PFObject]()
                    if objects.count == 0 {
                        let alert = UIAlertController(title: "Error", message: "We cannot load your submissions because you do not have any!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        for object in objects {
                            self.submissions.append(object)
                        }
                    }
                    self.collectionView.reloadData()
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PortfolioCell", forIndexPath: indexPath) as PortfolioCell
        cell.setImage(submissions[indexPath.row].objectForKey("image").url)
        return cell
    }
    
    @IBAction func closePortfolio(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}