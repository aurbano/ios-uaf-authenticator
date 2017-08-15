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
    
    let assertions = Assertion()
    
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

        let fc = assertions.getFC(fc: challenge).toHexString()
        XCTAssertEqual(fc, result)
    }
    
    func testBase64StringToByteArray() {
        let encodedMessage = "NEkxTjdidVR0UjBOSUNxZDVkSnQ="
        let expectedValue = Array<UInt8>("4I1N7buTtR0NICqd5dJt".utf8)
        guard let decodedMessage = assertions.base64ToByteArray(base64String: encodedMessage) else {
            print("Message could not be decoded")
            return
        }
        
        XCTAssertEqual(expectedValue, decodedMessage)
        
    }
    
    func testGetSignature() {
//        let message = Array<UInt8>("ZJsAMg6cfeh48yfZIIMC".utf8)
//        let value = assertions.getSignature(signedDataValue: message)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
