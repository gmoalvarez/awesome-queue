//
//  QTests.swift
//  QTests
//
//  Created by Archie on 10/23/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import XCTest
@testable import Q

class QTests: XCTestCase {
    
    //  Test done with these 8 test users. The password for all of them is pass
    let testUsers = ["test1","test2","test3","test3","test4","test5","test6","test7","test8"]
    
    
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
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
