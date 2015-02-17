//
//  ViewController.swift
//  Outfitter
//
//  Created by Michael Luo on 2/2/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PFLogInViewControllerDelegate {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        
        var logInController = PFLogInViewController()
        logInController.fields = (PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.Facebook)
        let newLogo = UILabel()
        newLogo.textColor = UIColor.blackColor()
        newLogo.text = "Outfitter"
        newLogo.sizeToFit()
        logInController.logInView.logo=newLogo
        self.presentViewController(logInController, animated:false, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

