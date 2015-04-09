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

class BrowseViewControllerTest: BaseTests {
    
    var viewController: BrowseViewController!
    var listOfRatings = [String]()
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("BrowseViewController") as BrowseViewController
        
        viewController.loadView()
    }
    
    override func tearDown() {
        super.tearDown()
        cleanUpLikes()
    }
    
    func cleanUpLikes(){
        if listOfRatings.count > 0 {
            for rating in listOfRatings {
                removeLikeOrDislike(rating, currentUserId: PFUser.currentUser().objectId)
            }
            listOfRatings.removeAll(keepCapacity: false)
        }
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
        XCTAssertNil(v.submissions,"No submissions loaded yet")
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
    
    func removeLikeOrDislike(objectId: String, currentUserId: String)
    {
        var ratingQuery = PFQuery(className:"RatingActivity")
        ratingQuery.whereKey("submissionId", equalTo: objectId)
        ratingQuery.whereKey("userId", equalTo: currentUserId)
        ratingQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        object.delete()
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    func testSubmitRatingDislike()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
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
        
        
        let expectation2 = self.expectationWithDescription("Submit Rating")
        
        func ratingCallback(result:Bool){
            XCTAssertTrue(result);
            listOfRatings.append(v.submissions[0].objectId)
            expectation2.fulfill()
        }
        
        v.submitRatingActivity(v.submissions[0].objectId, userId: PFUser.currentUser().objectId, votedYes: false, ratingCallback)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testSubmitRatingLike()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
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
        
        
        let expectation2 = self.expectationWithDescription("Submit Rating")
        
        func ratingCallback(result:Bool){
            XCTAssertTrue(result);
            expectation2.fulfill()
            listOfRatings.append(v.submissions[0].objectId)
        }
        
        v.submitRatingActivity(v.submissions[0].objectId, userId: PFUser.currentUser().objectId, votedYes: false, ratingCallback)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testSubmitRatingSubmissionsListDecreasesByOne()
    {
        // we only have access to this if we import our project above
        let v = viewController
        
        
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        v.currentSubmissionIndex = -1
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
        
        let oldSubmissionsCount = v.submissions.count
        let expectation2 = self.expectationWithDescription("Submit Rating")
        
        func ratingCallback(result:Bool){
            XCTAssertTrue(result);
            
            expectation2.fulfill()
        }
        
        let submissionObjectId = v.submissions[0].objectId
        listOfRatings.append(v.submissions[0].objectId)
        v.submitRatingActivity(v.submissions[0].objectId, userId: PFUser.currentUser().objectId, votedYes: false, ratingCallback)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
        
        let expectation3 = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        v.submissions = [PFObject]()
        func submissionsCallBack3() {
            NSLog("HERE")
            NSLog(String(v.submissions.count))
            NSLog(String(oldSubmissionsCount))
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            XCTAssertTrue(v.submissions.count<=oldSubmissionsCount)
            expectation3.fulfill()
        }
        
        v.getSubmissions(submissionsCallBack3)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testLoadCurrentPictureNoPictures()
    {
        // we only have access to this if we import our project above
        let v = viewController
        v.submissions = [PFObject]()
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        v.loadCurrentPicture()
        XCTAssertNil(v.currentImageView.image,"Current imageView not nil")
        
    }
    
    func testLoadCurrentPictureValidPictures()
    {
        // we only have access to this if we import our project above
        let v = viewController
       
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack() {
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            v.currentSubmissionIndex=0
            expectation.fulfill()
        }
        
        v.getSubmissions(submissionsCallBack)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
        
        v.loadCurrentPicture()
        XCTAssertNotNil(v.currentImageView.image,"Current imageView is not supposed to be nil")
        
    }
    
    func testArticleFilterFullOutfit()
    {
        let v = viewController
        
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack(){
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            for sub in v.submissions {
                XCTAssertTrue(sub.objectForKey("article") as Int! == 0, "Object of correct article")
            }
            expectation.fulfill()
        }
        v.getSubmissions(submissionsCallBack, articleId: 0)
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testArticleFilterTops()
    {
        let v = viewController
        let articleIdToPass = 1
        
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack(){
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            for sub in v.submissions {
                XCTAssertTrue(sub.objectForKey("article") as Int! == articleIdToPass, "Object of correct article")
            }
            expectation.fulfill()
        }
        v.getSubmissions(submissionsCallBack, articleId: articleIdToPass)
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testArticleFilterBottoms()
    {
        let v = viewController
        let articleIdToPass = 2
        
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack(){
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            for sub in v.submissions {
                XCTAssertTrue(sub.objectForKey("article") as Int! == articleIdToPass, "Object of correct article")
            }
            expectation.fulfill()
        }
        v.getSubmissions(submissionsCallBack, articleId: articleIdToPass)
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testArticleFilterShoes()
    {
        let v = viewController
        let articleIdToPass = 3
        
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack(){
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            for sub in v.submissions {
                XCTAssertTrue(sub.objectForKey("article") as Int! == articleIdToPass, "Object of correct article")
            }
            expectation.fulfill()
        }
        v.getSubmissions(submissionsCallBack, articleId: articleIdToPass)
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testArticleFilterAcc()
    {
        let v = viewController
        let articleIdToPass = 4
        
        v.currentSubmissionIndex = -1
        v.currentImageView.image = nil
        let expectation = self.expectationWithDescription("Load submissions")
        
        // assert that the ViewController.view is not nil
        XCTAssertNil(v.submissions,"No submissions loaded yet")
        v.submissions = [PFObject]()
        func submissionsCallBack(){
            XCTAssertTrue(v.submissions.count > 0,"Submissions were loaded")
            for sub in v.submissions {
                XCTAssertTrue(sub.objectForKey("article") as Int! == articleIdToPass, "Object of correct article")
            }
            expectation.fulfill()
        }
        v.getSubmissions(submissionsCallBack, articleId: articleIdToPass)
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
}



