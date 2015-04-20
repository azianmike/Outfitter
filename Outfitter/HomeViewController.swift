//
//  ViewController.swift
//  Outfitter
//
//  Created by Michael Luo on 2/2/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, PFLogInViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var welcomeMessage: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        // Do any additional setup after loading the view, typically from a nib.
        updateWelcomeMessage()
        showLoginView()
        
    }
    
    func showLoginView(){
        if (PFUser.currentUser() == nil) {
            var logInController = PFLogInViewController()
            logInController.fields = (PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.Facebook)
            logInController.delegate=self
            let newLogo = UILabel()
            newLogo.textColor = UIColor.blackColor()
            newLogo.text = "Outfitter"
            newLogo.sizeToFit()
            logInController.logInView.logo=newLogo
            self.presentViewController(logInController, animated:true, completion: nil)
        }
    }
    
    @IBAction func logout(){
        PFUser.logOut()
        var currentUser = PFUser.currentUser() // this will now be nil
        
        showLoginView()
    }
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser!) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        updateWelcomeMessage()

    }
    
    
    func updateWelcomeMessage(){
        if (PFUser.currentUser() == nil){
            return
        }
        
        if (FBSession.activeSession().isOpen)
        {
            FBRequest.requestForMe().startWithCompletionHandler({ (FBRequestConnection connected, FBGraphUser user, NSError error) -> Void in
                let currentUser=PFUser.currentUser()
                //currentUser.username=user.name
                currentUser.setValue(user.name, forKey: "name")
                currentUser.email = user.email
                
                PFUser.currentUser().save()
                self.welcomeMessage.text = "Welcome back " + user.name
            })
        }else{
            self.welcomeMessage.text = "Welcome back " + PFUser.currentUser().username

        }
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentPhotoSubmissionController(image)
    }*/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentPhotoSubmissionController(image)
    }
    
    func presentPhotoSubmissionController(image:UIImage!) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        // Force the downcast as an AnsViewController (this could crash at runtime
        // if the return value is nil or not an AnsViewController, so again,
        // the previous example is safer
        let ansViewController: UIViewController! = storyBoard.instantiateViewControllerWithIdentifier("SubmitPhotoViewController") as! UIViewController
        ansViewController.setValue(image, forKey: "imageToSubmit")
        self.presentViewController(ansViewController, animated:true, completion:nil)
    }

    
    @IBAction func takePhoto()
    {
        NSLog("enter takephoto")
        let temp = UIImagePickerController();
        temp.delegate = self;
        temp.sourceType = UIImagePickerControllerSourceType.Camera;
        self.presentViewController(temp, animated: true, completion: nil)
        
        
    }
    
    @IBAction func showPortfolio(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let portfolioViewController: UIViewController! = storyBoard.instantiateViewControllerWithIdentifier("PortfolioViewController") as! UIViewController
        self.presentViewController(portfolioViewController, animated:true, completion:nil)
    }
    
    @IBAction func showBrowseView(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let portfolioViewController: UIViewController! = storyBoard.instantiateViewControllerWithIdentifier("BrowseViewController") as! UIViewController
        self.presentViewController(portfolioViewController, animated:true, completion:nil)
    }
}

