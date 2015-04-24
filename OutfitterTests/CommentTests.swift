//
//  CommentTests.swift
//  Outfitter
//
//  Created by Yusuf on 4/23/15.
//  Copyright (c) 2015 Outfitter Group. All rights reserved.
//

import Foundation


import UIKit
import XCTest
import Outfitter


class CommentTests: BaseTests {
    
    var viewController: BrowseViewController!
    var listOfRatings = [String]()
    
    override func setUp() {
        
        super.setUp();
        
        viewController = storyBoard.instantiateViewControllerWithIdentifier("BrowseViewController") as! BrowseViewController
        
        viewController.loadView()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetComments()
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
        
        let expectation2 = self.expectationWithDescription("Get Comments")
        
        v.storyBoard = storyBoard
        v.currentSubmissionIndex = 0
        v.setupCommentController()
        

        func commentsCallBack(){
            XCTAssertTrue(v.commentController.comments.count > 0,"Comments were loaded")
            expectation2.fulfill()
        }
        
        v.commentController.getComments(commentsCallBack)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
    }
    
    func testAddComment()
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
        
        let expectation2 = self.expectationWithDescription("Get Comments")
        
        v.storyBoard = storyBoard
        v.currentSubmissionIndex = 0
        v.setupCommentController()
        
        
        func commentsCallBack(){
            XCTAssertTrue(v.commentController.comments.count > 0,"Comments were loaded")
            expectation2.fulfill()
        }
        
        v.commentController.getComments(commentsCallBack)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
        
        
        let expectation3 = self.expectationWithDescription("Add Comment")
        
        let oldCommentCount = v.commentController.comments.count;
        
        func addCommentCallBack(){
            expectation3.fulfill()
        }
        
        let filterDict = ["fuck":"f**k", "cunt":"c**t", "ass":"@$$", "Boobs":"80085", "cock":"penis", "dick":"penis", "pussy":"vagina", "faggot":"nice person", "fag":"nice person", "slut":"sexually popular woman"]
        
        v.commentController.addComment("Hi", submissionId: v.commentController.submissionID, userId: PFUser.currentUser().objectId, callback: addCommentCallBack, filterDictionary: filterDict)
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
        
        let expectation4 = self.expectationWithDescription("Load Comments")

        func addCommentLoadCommentsCallBack(){
            XCTAssertTrue(v.commentController.comments.count == oldCommentCount+1,"Comment was added")
            expectation4.fulfill()
        }
        
        v.commentController.comments = [PFObject]()
        v.commentController.getComments(addCommentLoadCommentsCallBack)

        self.waitForExpectationsWithTimeout(5.0) { (error) in
            if(error != nil) {
                XCTFail("FAILED due to " + error.description)
            }
        }
        
    }
    
    func testFilterBadWords()
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
        
        v.storyBoard = storyBoard
        v.currentSubmissionIndex = 0
        v.setupCommentController()
        
        let filterDict = ["ASDFASDF":"COOL"]
        let dirtyStr = "This is a ASDFASDF word"
        let newStr = "This is a COOL word"
        var cleanedStr = v.commentController.filterBadWords(dirtyStr, filterDictionary: filterDict)
        
        XCTAssertTrue(newStr == cleanedStr,"clean word filtered")
    }
    
}





