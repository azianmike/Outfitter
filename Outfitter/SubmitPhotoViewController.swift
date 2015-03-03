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
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        imageToSubmit = self.valueForKey("imageToSubmit") as UIImage
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
    

}
