//
//  OutfitterTests.swift
//  OutfitterTests
//
//  Created by Michael Luo on 2/2/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import UIKit
import XCTest
import Outfitter


class OutfitterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        //let logInController = ViewController()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // we can't do much  without a view on our root View Controller
    func testViewDidLoad()
    {
        // we only have access to this if we import our project above
        let v = HomeViewController()
        
        // assert that the ViewController.view is not nil
        XCTAssertNotNil(v.view, "View Did Not load")
    }
    
}

class BaseTests: XCTestCase {
    var storyBoard: UIStoryboard!
    var appDelegate: AppDelegate!

    override func setUp() {
        
        appDelegate = AppDelegate()
        
        appDelegate.setupAPIS()
        
        storyBoard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
    }
}

class HomeViewControllerTests: BaseTests {
    
    var viewController: HomeViewController!
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("HomeViewController") as HomeViewController
        
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

class SubmitPhotoViewControllerTests: BaseTests {
    
    var viewController: SubmitPhotoViewController!
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("SubmitPhotoViewController") as SubmitPhotoViewController
        
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

    func testShowSubmitPhotoController()
    {
        let mockImage = UIImage(named: "outfitter-logo")
        viewController.setValue(mockImage, forKey: "imageToSubmit")
        XCTAssertNotNil(viewController.imageToSubmit,"Not Nil")
    }
    
    func testSuccessfulSubmission()
    {
        
        let mockImage = UIImage(named: "outfitter-logo")
        viewController.setValue(mockImage, forKey: "imageToSubmit")

        let expectation = self.expectationWithDescription("submit photo callback successful")

        func submissionCallback(result:Bool) -> Void {
            XCTAssertTrue(result);
            expectation.fulfill()
        }
      
        viewController.submitPhotoToParse(mockImage!, articleID: 1, femaleFeedback: true, maleFeedback: true, submitPriority: true, submissionCallback)
        
        self.waitForExpectationsWithTimeout(15.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    /*func testUnsuccessfulSubmissionNoPhoto()
    {
        let mockImage = UIImage()
        
        func submissionCallback(result:Bool) -> Void {
            XCTAssertTrue(result);
        }
        
        viewController.submitPhotoToParse(mockImage, articleID: 1, femaleFeedback: true, maleFeedback: true, submitPriority: true, submissionCallback)
        
        /* throws no longer exists in xcode 6 :( */
       // XCTAssertThrows(submissionCallback(true), "");

    }*/

    
}


class PortfolioViewControllerTests: BaseTests {
    
    var viewController: PortfolioViewController!
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("PortfolioViewController") as PortfolioViewController
        
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
    
    func testGetSubmissions()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions?,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack() {
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            expectation.fulfill()
        }
        
        v.getSubmissions(submissionsCallBack)
    
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }

    }

    
}



