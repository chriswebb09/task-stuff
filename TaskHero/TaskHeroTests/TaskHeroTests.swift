//
//  TaskHeroTests.swift
//  TaskHeroTests
//
//  Created by Christopher Webb-Orenstein on 12/8/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import TaskHero

class TaskHeroTests: XCTestCase {
    var tabbarVC: TabBarController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        var loginVC = LoginViewController()
        //XCTAssertNotNil(tabbarVC.store.currentUser)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
