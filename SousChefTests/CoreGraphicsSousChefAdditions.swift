//
//  CoreGraphicsSousChefAdditions.swift
//  SousChefTests
//
//  Created by Jonathan Long on 7/21/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import XCTest

class CoreGraphicsSousChefAdditions: SousChefTestCase {
    
    func testSortedTopToBottomLeftToRightHigherToLower() {
        let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
        let rect2 = CGRect(x: 0, y: 100, width: 100, height: 100)
        
        XCTAssertTrue(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightLeadingToTrailing() {
        let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
        let rect2 = CGRect(x: 1, y: 0, width: 100, height: 100)
        
        XCTAssertTrue(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightLeadingToTrailingAndHigherToLower() {
        let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
        let rect2 = CGRect(x: 1, y: 1, width: 100, height: 100)
        
        XCTAssertTrue(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightSameRect() {
        let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
        let rect2 = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        XCTAssertTrue(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightLowerToHigher() {
        let rect1 = CGRect(x: 0, y: 1, width: 100, height: 100)
        let rect2 = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        XCTAssertFalse(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightTrailingToLeading() {
        let rect1 = CGRect(x: 1, y: 0, width: 100, height: 100)
        let rect2 = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        XCTAssertFalse(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
    
    func testSortedTopToBottomLeftToRightTrailingToLeadingLowerToHigher() {
        let rect1 = CGRect(x: 1, y: 1, width: 100, height: 100)
        let rect2 = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        XCTAssertFalse(CGRect.sortedTopToBottomLeftToRight(rect1: rect1, rect2: rect2))
    }
}
