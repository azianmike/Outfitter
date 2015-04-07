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
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        image = self.valueForKey("image") as UIImage
        selectedImage.image = image
        submissionObj = self.valueForKey("submissionObj") as SubmissionObject
        NSLog(submissionObj.getObjectID())
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}