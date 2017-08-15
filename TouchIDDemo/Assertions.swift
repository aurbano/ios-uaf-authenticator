//
//  Assertions.swift
//  TouchIDDemo
//
//  Created by Iva on 11/08/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import Foundation
import Gloss
import CryptoSwift

class Assertions: Glossy {
    var assertionScheme: String?
    var assertion: String?
    
    init(fcParams: String) {
        let assertObj = Assertion()
        self.assertion = assertObj.buildAssertions(fcParams: fcParams)
        self.assertionScheme = "UAFV1TLV"
    }
    
    required init?(json: JSON) {
        self.assertionScheme = "assertionScheme" <~~ json
        self.assertion = "assertion" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "assertionScheme" ~~> self.assertionScheme,
            "assertion" ~~> self.assertion
            ])
    }
}

class Assertion: NSObject {
    var aaid: String?
    var assertionInfo: String?
    var finalChallenge: String?
    var keyID: String?
    var counter: Bool?
    var pubKey: String?
    static let AAID = "EBA0#0001"
    
    func buildAssertions(fcParams: String) -> String? {
        let assertionBuilder = AssertionBuilder()
        return assertionBuilder.getAssertions(fc: fcParams)
    }
}
