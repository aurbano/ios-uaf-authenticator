//
//  AssertionTests.swift
//  TouchIDDemo
//
//  Created by Iva on 10/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import XCTest
import CryptoSwift
@testable import TouchIDDemo

class AssertionTests: XCTestCase {
    
    var assertion = Assertion()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetFC() {
        let challenge = "cnmip5SHIJWm21TRQFxI"
        
        let result = "8d41a5dd0fb044685323e11e999a00b0a48e17456df56d8a6912b4224a8c626e"

        let fc = assertion.getFC(fc: challenge).toHexString()
        XCTAssertEqual(fc, result)
    }
    
    func testGetSignature() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
