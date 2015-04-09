//
//  PortfolioSubmissionViewControllerTests.swift
//  Outfitter
//
//  Created by Ian Eckles on 4/9/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit
import XCTest
import Outfitter


class PortfolioSubmissionViewControllerTests: BaseTests {
    var viewController: PortfolioSubmissionViewController!
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("PortfolioSubmissionViewController") as PortfolioSubmissionViewController
        
        viewController.loadView()
    }
    
    func testViewDidLoad()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        // assert that the ViewController.view is not nil
        XCTAssertNotNil(v.view,"Not Nil")
    }
    
    func testUserExists()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        // assert that the ViewController.view is not nil
        XCTAssertNotNil(PFUser.currentUser(),"Not Nil")
    }
}
