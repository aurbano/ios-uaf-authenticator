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
    private var privKeyTag: String?
    
    init(fcParams: String) {
        let assertObj = Assertion()
        self.assertion = assertObj.buildAssertions(fcParams: fcParams)
        self.assertionScheme = "UAFV1TLV"
        
        self.privKeyTag = assertObj.getKeyTag()
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
    
    func getPrivKeyTag() -> String? {
        return self.privKeyTag
    }
}

class Assertion {
    var aaid: String?
    var assertionInfo: String?
    var finalChallenge: String?
    var keyID: String?
    var counter: Bool?
    var pubKey: String?
    static let AAID = "EBA0#0001"
    private let assertionBuilder: AssertionBuilder
    
    init() {
        assertionBuilder = AssertionBuilder()
    }
    
    func buildAssertions(fcParams: String) -> String? {
        return assertionBuilder.getAssertions(fc: fcParams)
    }
    
    func getKeyTag() -> String {
        return assertionBuilder.getPrivKeyTag()
    }
}
