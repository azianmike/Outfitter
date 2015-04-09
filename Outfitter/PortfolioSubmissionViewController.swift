//
//  PortfolioSubmissionViewController.swift
//  Outfitter
//
//  Created by Michael Luo on 4/7/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

public class PortfolioSubmissionViewController: UIViewController {
    
    var image:UIImage!
    @IBOutlet var selectedImage:UIImageView!
    var submissionObj:SubmissionObject!
    
    @IBOutlet var outfitType:UISegmentedControl!
    @IBOutlet var genderFeedback:UISegmentedControl!
    var ratings:[PFObject]!
    //var negativeRatings:[PFObject]!
    @IBOutlet var likePercent :UILabel!
    @IBOutlet var dislikePercent :UILabel!
    @IBOutlet var totalRatings :UILabel!
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        image = self.valueForKey("image") as UIImage
        selectedImage.image = image
        submissionObj = self.valueForKey("submissionObj") as SubmissionObject
        let articleNum = submissionObj.getArticle()
        
        outfitType.selectedSegmentIndex=articleNum
        outfitType.userInteractionEnabled=false
        
        let maleFeedback = submissionObj.getMaleFeedback()
        let femaleFeedback = submissionObj.getFemaleFeedback()
        if (maleFeedback & femaleFeedback){
            genderFeedback.selectedSegmentIndex=0
        }else if (maleFeedback!)
        {
            genderFeedback.selectedSegmentIndex=1
        }else if (femaleFeedback!)
        {
            genderFeedback.selectedSegmentIndex=2
        }
        genderFeedback.userInteractionEnabled = false
        
        ratings = [PFObject]()
        getImageStats(callback)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePortfolio(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func callback(){
        NSLog("enter callback")
        var likeCount = 0
        var dislikeCount = 0
        for object in ratings{
            if object.objectForKey("votedYes") as Bool{
                likeCount += 1
            }else{
                dislikeCount += 1
            }
        }
        if dislikeCount == 0 && likeCount == 0
        {
            likePercent.text = "100"
            dislikePercent.text = "0"
        }
        var likeFloat = Double(likeCount)
        var dislikeFloat = Double(dislikeCount)
        likePercent.text = String(format:"%.2f",likeFloat/(likeFloat+dislikeFloat) * 100)
        dislikePercent.text = String(format:"%.2f",dislikeFloat/(likeFloat+dislikeFloat) * 100)
        totalRatings.text = "Total Ratings: " + String(likeCount+dislikeCount)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func getImageStats(callback:(()->Void)){
        var query = PFQuery(className:"RatingActivity")
        query.whereKey("submissionId", equalTo:submissionObj.objectID)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading Data"
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.ratings.append(object)
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
}



